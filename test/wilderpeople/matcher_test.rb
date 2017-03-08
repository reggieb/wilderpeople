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

    def test_exact_with_extra_spaces
      assert_with_set(
        method: :exact,
        input: 'robert',
        resultset: {
          'robert' => true,
          ' robert' => true,
          'robert ' => true,
          ' robert ' => true
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

    def test_hypocorism
      assert_with_set(
        method: :hypocorism,
        input: 'robert',
        resultset: {
          'robert' => true,
          'rob ert' => false,
          'rob' => true,
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

    def test_date
      assert_with_set(
        method: :date,
        input: '3/5/2001',
        resultset: {
          '3/5/2001' => true,
          ' 3/5/2001 ' => true,
          '03/05/2001' => true,
          '5/3/2001' => false,
          '3-May-2001' => true,
          '21/06/2001' => false,
          '4/5/2001' => false,
          'foo' => false,
          '' => false
        }
      )
    end

    def test_fuzzy_date
      assert_with_set(
        method: :fuzzy_date,
        input: '3/5/2001',
        resultset: {
          '3/5/2001' => true,
          ' 3/5/2001 ' => true,
          '03/05/2001' => true,
          '5/3/2001' => true,
          '3-May-2001' => true,
          '21/06/2001' => false,
          '4/5/2001' => false,
          'foo' => false,
          '' => false
        }
      )
    end

    def test_fuzzy
      assert_with_set(
        method: :fuzzy,
        input: 'robert',
        resultset: {
          'robert' => true,
          'rob ert' => true,
          'rob' => false,
          'robertson' => false,
          'foo' => false,
          'nobert' => true,
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
