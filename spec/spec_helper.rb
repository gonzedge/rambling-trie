require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'rspec'
require 'rambling-trie'
::SPEC_ROOT = File.dirname(__FILE__)

RSpec.configure do |config|
  config.order = :random
  config.formatter = :documentation

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
