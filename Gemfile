# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'rubyzip'

group :development do
  gem 'benchmark-ips'
  gem 'flamegraph'
  gem 'memory_profiler'
  gem 'pry'
  gem 'ruby-prof'
  gem 'stackprof'
end

group :test do
  gem 'coveralls_reborn', require: false
  gem 'rspec_junit_formatter'
  gem 'simplecov', require: false
end

group :local do
  gem 'flog', require: false
  gem 'guard-rspec'
  gem 'reek', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end
