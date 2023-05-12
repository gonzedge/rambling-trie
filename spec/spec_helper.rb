# frozen_string_literal: true

require 'yaml'
require 'simplecov'

COVERAGE_FILTER = %r{/spec/}.freeze

if ENV.key? 'COVERALLS_REPO_TOKEN'
  require 'coveralls'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]

  Coveralls.wear! { add_filter COVERAGE_FILTER }
else
  SimpleCov.start { add_filter COVERAGE_FILTER }
end

require 'rspec'
require 'rambling-trie'
::SPEC_ROOT = File.dirname __FILE__

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.order = :random
  config.filter_run_when_matching :focus
  config.raise_errors_for_deprecations!
end

require 'support/config'

%w(
  a_compressible_trie a_serializable_trie a_serializer a_trie_data_structure
  a_trie_node a_trie_node_implementation a_container_scan a_container_word
  a_container_partial_word a_container_words_within
).each do |name|
  require File.join('support', 'shared_examples', name)
end
