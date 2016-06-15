module RedisModel
  # = JsonAttributes
  #
  # This module adds JSON serializable attributes support to RedisModel::Base
  #
  # == Example
  #
  #   class Model < RedisModel::Base
  #     ATTRS = [:name]
  #     attr_accessor(*ATTRS)
  #
  #     # Use json_attr method to add attributes
  #     # parameter:  attribute name
  #     json_attr :array_field
  #     json_attr :hash_field
  #
  #     validates :name, presence: true
  #   end
  #
  #   model = Model.new
  #   model.array_field = ['White', 'Black']
  #   model.hash_field = { one: 1, two: 2 }
  #   model.save
  module JsonAttributes
    #
    # Adds JSON serializable attribute to model
    #
    def json_attr(name)
      # Attribute name to store object as json
      json_attr_name = "#{name}_json".to_sym

      # Add field to model
      self::ATTRS.push(json_attr_name)
      attr_accessor json_attr_name

      # Define getter
      define_method(name) do
        json_data = send(json_attr_name)
        json_data ? JSON.parse(json_data) : nil
      end

      # Define setter
      define_method("#{name}=") do |value|
        send("#{json_attr_name}=", value.to_json)
      end
    end
  end
end
