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

    def config
      {
        must: {
          surname: :exact,
          dob: :fuzzy_date,
          postcode: :transposed,
          street_name: :exact_except_last_word
        },
        can: {
          gender: :first_letter,
          house_number: :exact,
          house_name: :exact,
          postcode: :exact_no_space,
          firstname: :hypocorism
        }
      }
    end
  end
end

