require 'test_helper'

# Model for testing json attributes
class Model < RedisModel::Base
  ATTRS = [:name]
  attr_accessor(*ATTRS)

  json_attr :array_field
  json_attr :hash_field

  validates :name, presence: true
end

# JsonAttributes test
class JsonAttributesTest < ActiveSupport::TestCase
  test 'should save and load data' do
    test_data = {
      name: 'test',
      hash_field: { 'obj1' => 1, 'obj2' => 'two' },
      array_field: %w(one two)
    }

    # Save data
    model = Model.new

    test_data.each do |key, value|
      model.send("#{key}=", value)
    end

    model.save!

    # Load and check data
    loaded = Model.find(model.id)

    test_data.each do |key, value|
      assert_equal(value, loaded.send(key), "#{key} is incorrect")
    end

    # Clean after test
    $redis.del(model.key)
  end
end
