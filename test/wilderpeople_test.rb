require 'test_helper'

class WilderpeopleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Wilderpeople::VERSION
  end

  def test_people_in_parts
    assert_kind_of Hash, people_in_parts
    assert_kind_of String, people_in_parts['one']['title']
    assert_kind_of String, people_in_parts[:one][:title]
  end

end
