require 'minitest/autorun'
require 'fakeredis'
require 'redis-model'

REDIS_TTL = 1.1
$redis = Redis.new

Time.zone = 'UTC'

class ActiveSupport::TestCase
  setup do
    $redis.flushdb
  end
end
