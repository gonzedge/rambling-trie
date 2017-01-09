RSpec.configure do |c|
  c.before do
    Rambling::Trie.config.reset
  end
end
