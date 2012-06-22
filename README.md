# Redis-Model

Redis backed models which auto expires. This can be done with memcache
but Redis provides the flexibility to expand the functionality in the
future

## Installation

Add this line to your application's Gemfile:

    gem 'redis-model'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-model

The gem expects `REDIS_TTL` & `$redis` to be defined. `REDIS_TTL` is the time
in seconds the record lives in redis. `$redis` is the redis client

## Usage

The class should define its attributes in a `ATTRS` variable and define getters
and setters.

```ruby
class Email
  ATTRS = [:id, :from, :to, :subject]
  attr_accessor *ATTRS
  include RedisModel::Base
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
