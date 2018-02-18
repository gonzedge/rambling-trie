require 'simplecov'
require 'coveralls'

Coveralls.wear!

SimpleCov.formatters = [
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
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.order = :random
  config.run_all_when_everything_filtered = true
  config.raise_errors_for_deprecations!
end

require 'support/config'
require 'support/shared_examples/a_compressible_trie'
require 'support/shared_examples/a_serializable_trie'
require 'support/shared_examples/a_serializer'
require 'support/shared_examples/a_trie_data_structure'
require 'support/shared_examples/a_trie_node'
require 'support/shared_examples/a_trie_node_implementation'
