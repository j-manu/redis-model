require 'active_support'
# We just need the Time.zone functionality but has to pull in
# core_ext because activesupport has changed where the
# zones functionality is defined between versions
require 'active_support/core_ext'
require 'active_model'

require "redis-model/version"
require "redis-model/json_attributes.rb"
require "redis-model/base"
