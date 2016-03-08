module Rambling
  module Trie
    # A representation of the root node in the Trie data structure.
    class Root < Node
      # Creates a new Trie.
      # @yield [Root] the trie just created.
      def initialize
        super
        self.compressed = false
        yield self if block_given?
      end

      # Adds a branch to the trie based on the word, without changing the passed word.
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see Branches#add
      # @note Avoids clearing the contents of the word variable.
      def add word
        super word.clone
      end

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

      alias_method :match?, :partial_word?

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

      alias_method :include?, :word?

      def scan word = ''
        closest_node(word).to_a
      end

      alias_method :words, :scan

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
