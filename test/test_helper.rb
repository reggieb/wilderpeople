$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wilderpeople'
require 'minitest/autorun'
require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

class Minitest::Test
  def fixture_path(path)
    File.expand_path(
      File.join('fixtures', path),
      File.dirname(__FILE__)
    )
  end

  def hash_from_yaml(path)
    YAML.load_file(
      "#{fixture_path(path)}.yml"
    ).with_indifferent_access
  end

  def people_in_parts
    hash_from_yaml 'people/in_parts'
  end

  def people_long_address
    hash_from_yaml 'people/long_address'
  end


end
