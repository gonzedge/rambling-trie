require_relative 'path'

module Helpers
  module Trie
    include Helpers::Path

    def tries
      [
        Rambling::Trie.load(raw_trie_path),
        Rambling::Trie.load(compressed_trie_path)
      ]
    end
  end
end
