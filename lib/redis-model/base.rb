module RedisModel

  class RecordNotFound < StandardError
  end

  class RecordNotSaved < StandardError
  end

  class Base
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks

    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Conversion

    attr_accessor :id, :created_at

    def self.create(attributes = {})
      instance = new(attributes.merge({created_at: Time.zone.now}))
      instance.save
    end

    def self.create!(attributes = {})
      instance = new(attributes.merge({created_at: Time.zone.now}))
      instance.save!
    end

    def self.find(id)
      hash = $redis.hgetall(key(id))
      if hash.present?
        new(hash)
      else
        raise RecordNotFound
      end
    end

    def self.key(id)
      "#{name.to_s.downcase}:#{id}"
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
      if save
        self
      else
        raise RecordNotSaved
      end
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
      $redis.hset(key, :id, @id)
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
