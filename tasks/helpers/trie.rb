require_relative 'path'

module Helpers
  module Trie
    include Helpers::Path

    def tries
      [
        raw_trie,
        compressed_trie
      ]
    end

    def raw_trie
      Rambling::Trie.load raw_trie_path
    end

    def compressed_trie
      Rambling::Trie.load compressed_trie_path
    end
  end
end
