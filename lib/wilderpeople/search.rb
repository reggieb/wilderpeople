require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
module Wilderpeople
  class Search
    attr_reader :data, :config
    def initialize(data: [], config: {})
      @data = data.collect(&:with_indifferent_access)
      @config = config
    end

    def find(args)
      result = select(args)
      return result.first if result.size == 1
    end

    def select(args)
      data.select do |datum|
        args.all? do |k,v|
          Matcher.by must_rules[k], datum[k], v
        end
      end
    end

    def must_rules
      config[:must]
    end
  end
end
