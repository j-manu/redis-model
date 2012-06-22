module RedisModel
  module Base
    attr_writer :created_at

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def create(attributes = {})
        instance = new(attributes.merge({created_at: Time.zone.now}))
        instance.save
      end

      def find(id)
        hash = $redis.hgetall(key(id))
        hash.present? ? new(hash) : nil
      end

      def key(id)
        "#{name.to_s.downcase}:#{id}"
      end
    end

    def initialize(attributes = {})
      set_attrs(attributes)
      self
    end

    def update_attributes(attributes = {})
      set_attrs(attributes)
      save_attrs
      self
    end

    def save
      return false unless valid?
      @id ||= generate_id
      save_attrs
      $redis.expire key, REDIS_TTL
      self
    end

    def save!
      save
    end

    def set_attrs(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def save_attrs
      self.class::ATTRS.each do |attr|
        $redis.hset(key, attr, send(attr))
      end
      $redis.hset(key, :created_at, @created_at || Time.zone.now)
    end

    def persisted?
      $redis.hgetall(key).present?
    end

    def created_at
      return unless @created_at
      Time.parse(@created_at.to_s)
    end

    def key
      "#{self.class.name.to_s.downcase}:#{id}"
    end

    def generate_id
      Time.now.to_i.to_s + '_' + SecureRandom.hex(3)
    end

  end
end
