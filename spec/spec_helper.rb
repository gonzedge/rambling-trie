require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'rambling-trie'
::SPEC_ROOT = File.dirname(__FILE__)
