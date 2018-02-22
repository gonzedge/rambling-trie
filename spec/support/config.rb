# frozen_string_literal: true

require_relative 'helpers/add_word'
require_relative 'helpers/one_line_heredoc'

RSpec.configure do |c|
  c.before do
    Rambling::Trie.config.reset
  end

  c.include Support::Helpers::AddWord
  c.include Support::Helpers::OneLineHeredoc

  RSpec::Matchers.define_negated_matcher :not_change, :change
end
