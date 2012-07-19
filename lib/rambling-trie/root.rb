module Rambling
  module Trie
    # A representation of the root node in the Trie data structure.
    class Root < Node
      # Creates a new Trie.
      # @param [String, nil] filename the file to load the words from (defaults to nil).
      def initialize(filename = nil)
        super(nil)

        @filename = filename
        @compressed = false
        add_all_nodes if filename
      end

      # Compresses the existing tree using redundant node elimination. Flags the trie as compressed.
      # @return [Root] same object
      def compress!
        @compressed = (not compress_tree!.nil?) unless compressed?
        self
      end

      # Flag for compressed tries. Overrides {Compressor#compressed?}.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        @compressed
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false` otherwise.
      def has_branch_for?(word = '')
        fulfills_condition word, :has_branch_for?
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last character corresponds to a terminal node.
      def is_word?(word = '')
        fulfills_condition word, :is_word?
      end

      alias_method :include?, :is_word?

      private
      def fulfills_condition(word, method)
        method = compressed? ? "compressed_#{method}" : "uncompressed_#{method}"
        send(method, word.chars.to_a)
      end

      def add_all_nodes
        File.open(@filename).each_line { |line| self << line.chomp }
      end
    end
  end
end
