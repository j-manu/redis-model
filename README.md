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
class Email < RedisModel::Base
  ATTRS = [:from, :to, :subject]
  attr_accessor *ATTRS
end
```
