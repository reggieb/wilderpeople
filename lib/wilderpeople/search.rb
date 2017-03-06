require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
class Search
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def find_by(args = {})
    select(args).first
  end

  def select(args = {})
    data.select do |datum|
      args.all? do |k,v|
        datum[k] == v
      end
    end
  end

  def data_with_indifferent_access
    @data_with_indifferent_access ||= data.collect(&:with_indifferent_access)
  end
end
