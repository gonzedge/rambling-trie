require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'rambling-trie'
::SPEC_ROOT = File.dirname(__FILE__)

RSpec.configure do |config|
  config.order = :random
end
