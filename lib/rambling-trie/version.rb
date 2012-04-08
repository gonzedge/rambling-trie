module Rambling
  unless defined?(Rambling::Trie::VERSION)
    # Current version of the rambling-trie.
    Rambling::Trie.const_set(:VERSION, '0.3.4')
  end
end
