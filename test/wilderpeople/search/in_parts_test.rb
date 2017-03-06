require 'test_helper'

module Wilderpeople
  class InPartsTest < Minitest::Test

    def test_find_by
      assert_equal people_in_parts[:two], search.find_by(surname: 'Smith')
    end

    def test_select
      people = [:one, :three].collect{|n| people_in_parts[n]}
      assert_equal people, search.select(surname: 'Nichols')
    end

    def search
      @search ||= Search.new(people_in_parts.values)
    end
  end
end

