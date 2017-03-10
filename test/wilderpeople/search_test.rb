require 'test_helper'
require 'ostruct'

module Wilderpeople
  class SearchTest < Minitest::Test

    def test_find
      result = search.find(
        surname: person.surname,
        dob: person.dob,
        postcode: person.postcode,
        street: person.street
      )
      assert_equal person_data, result
    end

    def test_find_with_small_data_divergence
      result = search.find(
        surname: person.surname,
        dob: '11/01/1966', # swap day and month
        postcode: 'CV1 2BA', # shuffled
        street: 'Some Rd' # Change last word: e.g. From 'Road' to 'Rd'
      )
      assert_equal person_data, result
    end

    def test_find_with_two_matching_results
      @config = { must: { surname: :exact } }
      assert_nil search.find( surname: person.surname )
    end

    def test_find_with_two_matching_results_separated_with_can
      @config = { must: { surname: :exact }, can: { forename: :exact } }
      result = search.find(
        surname: person.surname,
        forename: person.forename
      )
      assert_equal person_data, result
    end

    def test_find_with_two_matching_results_separated_with_can_and_extra_can
      @config = { must: { surname: :exact }, can: { title: :exact, dob: :exact, forename: :exact } }
      result = search.find(
        surname: person.surname,
        forename: person.forename,
        dob: person.dob,
        title: 'Foo'
      )
      assert_equal person_data, result
    end

    def test_select
      result = search.select(
        surname: person.surname,
        dob: person.dob,
        postcode: person.postcode,
        street: person.street
      )
      assert_equal [person_data], result
    end

    def test_select_with_small_data_divergence
      result = search.select(
        surname: person.surname,
        dob: '11/01/1966', # swap day and month
        postcode: 'CV1 2BA', # shuffled
        street: 'Some Rd' # Change last word: e.g. From 'Road' to 'Rd'
      )
      assert_equal [person_data], result
    end

    def test_select_with_two_matching_results
      @config = { must: { surname: :exact } }
      result = search.select( surname: person.surname )
      assert_equal 2, result.length
      assert_includes result, person_data
    end

    def test_select_with_two_matching_results_separated_with_can
      @config = { must: { surname: :exact }, can: { forename: :exact } }
      result = search.select(
        surname: person.surname,
        forename: person.forename
      )
      assert_equal [person_data], result
    end

    def search
      @search ||= Search.new(data: people_in_parts.values, config: config)
    end

    def config
      @config ||= {
        must: {
          surname: :exact,
          dob: :fuzzy_date,
          postcode: :transposed,
          street: :exact_except_last_word
        },
        can: {
          gender: :first_letter,
          house_number: :exact,
          house_name: :exact,
          postcode: :exact_no_space,
          forename: :hypocorism
        }
      }
    end

    def person
      @person ||= OpenStruct.new(people_in_parts[:one])
    end

    def person_data
      person.to_h.with_indifferent_access
    end
  end
end

