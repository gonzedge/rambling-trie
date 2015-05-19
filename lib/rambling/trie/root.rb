module Rambling
  module Trie
    # A representation of the root node in the Trie data structure.
    class Root < Node
      # Compresses the existing tree using redundant node elimination. Flags the trie as compressed.
      # @return [Root] self
      def compress!
        self.compressed = compressed? || !!compress_tree!
        self
      end

      # Flag for compressed tries. Overrides {Compressor#compressed?}.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        !!compressed
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false` otherwise.
      def partial_word? word = ''
        is? :partial_word, word
      end

      # If the current node is the root node.
      # @return [Boolean] `true`
      def root?
        true
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last character corresponds to a terminal node.
      def word? word = ''
        is? :word, word
      end

      # Returns all words that start with the specified characters.
      # @param [String] word the word to look for in the trie.
      # @return [Array] all the words contained in the trie that start with the specified characters.
      def scan word = ''
        closest_node(word).to_a
      end

      private

      attr_accessor :compressed

      def is? method, word
        method = compressed? ? "#{method}_when_compressed?" : "#{method}_when_uncompressed?"
        send method, word.chars.to_a
      end

      def closest_node word
        method = compressed? ? :closest_node_when_compressed : :closest_node_when_uncompressed

        send method, word.chars.to_a
      end
    end
  end
end
