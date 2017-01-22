module Helpers
  module Trie
    def tries
      require 'rambling-trie'

      [
        Rambling::Trie.load(raw_trie_path),
        Rambling::Trie.load(compressed_trie_path)
      ]
    end
  end
end
