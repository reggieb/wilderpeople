require 'active_support/core_ext/hash/indifferent_access'
module Wilderpeople
  class Search
    attr_reader :data, :config, :result, :args
    def initialize(data: [], config: {})
      @data = data.collect(&:with_indifferent_access)
      @config = config
    end

    def find(args)
      select(args)
      result.first if result.size == 1
    end

    def select(args)
      @result = data
      @args = args
      select_must
      select_can if result.size > 1
      result
    end

    private

    def select_must
      return if result.empty?
      return unless must_rules
      @result = result.select do |datum|
        must_rules.all? do |key, matcher_method|
          return false unless datum[key] && args[key]
          Matcher.by matcher_method, datum[key], args[key]
        end
      end
    end

    def must_rules
      config[:must]
    end

    def select_can
      return if result.empty?
      return unless can_rules
      # Get all of the matches for each of the can rules.
      matches = can_rules.collect do |key, matcher_method|
        result.select do |datum|
          [matcher_method, datum[key], args[key]]
          Matcher.by matcher_method, datum[key], args[key]
        end
      end
      # Then determine which items appears in more matches
      # than any other, and if so return those.
      occurrences = find_occurrences(matches)
      count_of_commonest = occurrences.values.max
      @result = occurrences.select{|_k, v| v == count_of_commonest}.keys
    end

    def can_rules
      config[:can]
    end

    # Returns a hash with each item as key, and the count of occurrences as value
    # See: http://jerodsanto.net/2013/10/ruby-quick-tip-easily-count-occurrences-of-array-elements/
    def find_occurrences(array)
      array.flatten.each_with_object(Hash.new(0)){ |item,count| count[item] += 1 }
    end

  end
end
