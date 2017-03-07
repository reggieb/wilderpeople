require 'hypocorism'
require 'date'
module Wilderpeople
  class Matcher

    def exact(a,b)
      prep(a,b)
      a == b
    end

    # All the right letters but not necessarily in the right order
    def transposed(a,b)
      return true if exact(a,b)
      exact *[a,b].collect{|x| x.chars.sort}
    end

    # Designed for matching street names, so don't have to worry about
    # Road/Rb and Street/St.
    def exact_except_last_word(a,b)
      return true if exact(a,b)
      words = [a,b].collect(&:split)
      exact *words.collect{|w| w.size == 1 ? w : w[0..-2]}
    end

    def first_letter(a,b)
      return true if exact(a,b)
      exact *[a,b].collect{|x| x[0]}
    end

    # Match 'Foo bar' with 'Foobar'
    def exact_no_space(a,b)
      return true if exact(a,b)
      exact *[a,b].collect{|x| x.gsub(/\s/, '')}
    end

    # Match English first names with alternative forms
    # So 'Robert' matches 'Rob'
    def hypocorism(a,b)
      Hypocorism.match(a,b)
    end

    # Matches dates, but also handles day and month being swapped.
    # So 3/5/2001 matches 5/3/2001
    def fuzzy_date(a,b)
      return true if exact(a,b)
      dates = [a, b].collect{|x| Date.parse(x)}
      return true if exact(*dates)
      return false if dates[1].day > 12
      exact(dates[0], swap_day_month(dates[1]))
    rescue ArgumentError # Error raised when entry won't parse
      false
    end

    def prep(*args)
      args.each do |a|
        case a
        when String
          a.downcase!
          a.strip! if a
        when Array
          a.collect{|x| prep(x)}
        else
          a
        end
      end
    end

    def swap_day_month(date)
      Date.new(date.year, date.day, date.month)
    end
  end
end
