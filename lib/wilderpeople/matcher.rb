require 'hypocorism'
require 'date'
require 'levenshtein'
module Wilderpeople
  class Matcher

    class << self
      attr_writer :levenshtein_threshold

      def levenshtein_threshold
        @levenshtein_threshold ||= 0.3
      end

      # Using `method_missing` so that instead of having to do:
      #   Matcher.new(a, b).exact
      # We can do
      #   Matcher.exact(a, b)
      def method_missing(method, *args, &block)
        if protected_instance_methods.include?(method)
          by(method, args[0], args[1])
        else
          super
        end
      end

      # Another way to use matcher is:
      #   Matcher.by :exact, a, b
      def by(method, a, b)
        raise "Method must be defined" unless method
        new(a, b).send(method)
      end
    end

    attr_reader :a, :b, :dates

    # Passing arguments into initialize so that prep can be done just once
    # and before main test.
    # Also means that I don't have to worry about the result of one match
    # poluting the next match
    def initialize(a, b)
      @a, @b = a.clone, b.clone
      prep
    end

    protected # note that method_missing looks for protected_instance_methods

    # `exact` used in other methods so needs to work with either stored `a` and `b`
    # or items passed into it
    def exact(x = a, y = b)
      x == y
    end

    # All the right letters but not necessarily in the right order
    def transposed
      return true if exact
      exact *[a,b].collect{|x| x.chars.sort}
    end

    # Designed for matching street names, so don't have to worry about
    # Road/Rb and Street/St.
    # Note that if matching one word, just that word is matched
    def exact_except_last_word
      return true if exact
      words = [a,b].collect(&:split)
      exact *words.collect{|w| w.size == 1 ? w : w[0..-2]}
    end

    def first_letter
      return true if exact
      exact *[a,b].collect{|x| x[0]}
    end

    # Match 'Foo bar' with 'Foobar'
    def exact_no_space
      return true if exact
      exact *[a,b].collect{|x| x.gsub(/\s/, '')}
    end

    # Match English first names with alternative forms
    # So 'Robert' matches 'Rob'
    def hypocorism
      Hypocorism.match(a,b)
    end

    # Match dates
    def date
      return true if exact
      @dates = [a, b].collect{|x| date_parse(x)}
      exact(*dates)
    rescue ArgumentError # Error raised when entry won't parse
      false
    end

    # Matches dates, but also handles day and month being swapped.
    # So 3/5/2001 matches 5/3/2001
    def fuzzy_date
      return true if date
      return false unless dates
      return false if dates[1].day > 12
      exact(dates[0], swap_day_month(@dates[1]))
    end

    def fuzzy(threshold = self.class.levenshtein_threshold)
      exact
      return false if a.empty? || b.empty?
      !!Levenshtein.normalized_distance(a,b, threshold)
    end

    private

    def prep
      [a,b].each do |attr|
        case attr
        when String
          attr.downcase!
          attr.strip! if attr
        when Array
          attr.collect{|x| prep(x)}
        else
          attr
        end
      end
    end

    def swap_day_month(date)
      Date.new(date.year, date.day, date.month)
    end

    def date_parse(string)
      Date.parse(string)
    rescue ArgumentError
      try_american_format(string)
    end

    def try_american_format(string)
      Date.strptime string, "%m/%d/%Y"
    rescue ArgumentError
      # Need to catch instance where system is using American format
      try_proper_format(string)
    end

    def try_proper_format(string)
      Date.strptime string, "%d/%m/%Y"
    end
  end
end
