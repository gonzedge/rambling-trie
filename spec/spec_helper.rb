require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'rspec'
require 'rambling-trie'
::SPEC_ROOT = File.dirname(__FILE__)

RSpec.configure do |config|
  config.order = :random
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
