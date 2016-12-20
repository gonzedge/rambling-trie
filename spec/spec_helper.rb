require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
end

require 'rspec'
require 'rambling-trie'
::SPEC_ROOT = File.dirname __FILE__

RSpec.configure do |config|
  config.order = :random
  config.run_all_when_everything_filtered = true
  config.raise_errors_for_deprecations!
end
