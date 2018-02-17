require_relative 'helpers/add_word'

RSpec.configure do |c|
  c.before do
    Rambling::Trie.config.reset
  end

  c.include Support::Helpers::AddWord
end
