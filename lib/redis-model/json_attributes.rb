module RedisModel
  # = JsonAttributes
  #
  # This module adds Hash and Array attributes support to RedisModel::Base
  #
  # == Example
  #
  #   class Model < RedisModel::Base
  #     ATTRS = [:name]
  #     attr_accessor(*ATTRS)
  #
  #     # Use json_attr method to add attributes
  #     # first parameter:  attribute name
  #     # second parameter: attribute type (Hash or Array)
  #     json_attr :array_field_name, Array
  #     json_attr :hash_field_name, Hash
  #
  #     validates :name, presence: true
  #   end
  #
  module JsonAttributes
    #
    # Adds Hash or Array attribute to model
    #
    def json_attr(name, type)
      raise 'Unsupported type' unless [Array, Hash].include?(type)

      # Attribute name to store object as json
      json_attr_name = "#{name}_json".to_sym

      # Add field to model
      self::ATTRS.push(json_attr_name)
      attr_accessor json_attr_name

      # Define getter
      define_method(name) do
        json_data = send(json_attr_name)
        json_data.present? ? JSON.parse(json_data) : type.new
      end

      # Define setter
      define_method("#{name}=") do |value|
        send("#{json_attr_name}=", value.to_json)
      end
    end
  end
end
