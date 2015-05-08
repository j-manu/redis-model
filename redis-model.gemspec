# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis-model/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Manu J"]
  gem.email         = ["manu@manu-j.com"]
  gem.description   = %q{Redis backed models}
  gem.summary       = %q{Redis backed models which auto expires}
  gem.homepage      = "https://github.com/j-manu/redis-model"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "redis-model"
  gem.require_paths = ["lib"]
  gem.version       = RedisModel::VERSION

  gem.add_dependency "redis",       ">= 2.2.2"
  gem.add_dependency 'tzinfo',     '>= 0.3'
  gem.add_dependency 'activesupport', '>= 3.2'
  gem.add_development_dependency "fakeredis"
end
