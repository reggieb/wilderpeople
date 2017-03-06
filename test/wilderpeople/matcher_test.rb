require 'test_helper'
module Wilderpeople
  class MatcherTest < Minitest::Test

    def test_exact
      assert_with_set(
        method: :exact,
        input: 'robert',
        resultset: {
          'robert' => true,
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

    def test_transposed
      assert_with_set(
        method: :transposed,
        input: 'robert',
        resultset: {
          'robert' => true,
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

    def test_exact_except_last_word
      assert_with_set(
        method: :exact_except_last_word,
        input: 'robert',
        resultset: {
          'robert' => true,
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

    def assert_with_set(method: '', input: '', resultset: {})
      resultset.each do |match, expected|
        assert_equal(
          expected,
          matcher.send(method, input, match),
          "'#{input}' should#{' not' unless expected} match '#{match}' with `matcher.#{method}`"
        )
      end
    end

    def matcher
      @matcher ||= Matcher.new
    end

  end
end
