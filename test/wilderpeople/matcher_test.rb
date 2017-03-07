require 'test_helper'
module Wilderpeople
  class MatcherTest < Minitest::Test

    def test_exact
      assert_with_set(
        method: :exact,
        input: 'robert',
        resultset: {
          'robert' => true,
          'rob ert' => false,
          'rob' => false,
          'robertson' => false,
          'foo' => false,
          'nobert' => false,
          'trebor' => false,
          'retbor' => false,
          'robert bruce' => false,
          '' => false
        }
      )
    end

    def test_exact_is_case_insensitive
      assert_with_set(
        method: :exact,
        input: 'foo',
        resultset: {
          'Foo' => true,
          'FOO' => true,
          'fOO' => true
        }
      )
    end

    def test_transposed
      assert_with_set(
        method: :transposed,
        input: 'robert',
        resultset: {
          'robert' => true,
          'rob ert' => false,
          'rob' => false,
          'robertson' => false,
          'foo' => false,
          'nobert' => false,
          'trebor' => true,
          'retbor' => true,
          'robert bruce' => false,
          '' => false
        }
      )
    end

    def test_transposed_with_alternative_case
      assert_with_set(
        method: :transposed,
        input: 'robert',
        resultset: {
          'Robert' => true,
          'Rob ert' => false,
          'Rob' => false,
          'Robertson' => false,
          'Foo' => false,
          'Nobert' => false,
          'Trebor' => true,
          'Retbor' => true,
          'Robert bruce' => false,
          '' => false
        }
      )
    end

    def test_exact_except_last_word
      assert_with_set(
        method: :exact_except_last_word,
        input: 'robert',
        resultset: {
          'robert' => true,
          'rob ert' => false,
          'rob' => false,
          'robertson' => false,
          'foo' => false,
          'nobert' => false,
          'trebor' => false,
          'retbor' => false,
          'robert bruce' => true,
          '' => false
        }
      )
    end

    def test_first_letter
      assert_with_set(
        method: :first_letter,
        input: 'robert',
        resultset: {
          'robert' => true,
          'rob ert' => true,
          'rob' => true,
          'robertson' => true,
          'foo' => false,
          'nobert' => false,
          'trebor' => false,
          'retbor' => true,
          'robert bruce' => true,
          '' => false
        }
      )
    end

    def test_exact_no_space
      assert_with_set(
        method: :exact_no_space,
        input: 'robert',
        resultset: {
          'robert' => true,
          'rob ert' => true,
          'rob' => false,
          'robertson' => false,
          'foo' => false,
          'nobert' => false,
          'trebor' => false,
          'retbor' => false,
          'robert bruce' => false,
          '' => false
        }
      )
    end

    def assert_with_set(method: '', input: '', resultset: {})
      resultset.each do |match, expected|
        assert_equal(
          expected,
          matcher.send(method, input, match.dup), # match is a hash key so frozen. Using dup to create unfrozen copy
          "'#{input}' should#{' not' unless expected} match '#{match}' with `matcher.#{method}`"
        )
      end
    end

    def matcher
      @matcher ||= Matcher.new
    end

  end
end
