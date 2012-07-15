module Rambling
  module Trie
    # A representation of the root node in the Trie data structure.
    class Root < Node
      # Creates a new Trie.
      # @param [String, nil] filename the file to load the words from (defaults to nil).
      def initialize(filename = nil)
        super(nil)

        @filename = filename
        @is_compressed = false
        add_all_nodes if filename
      end

      # Compresses the existing tree using redundant node elimination. Flags the trie as compressed.
      # @return [Trie] same object
      def compress!
        unless compressed?
          compress_own_tree!
          @is_compressed = true
        end

        self
      end

      # Flag for compressed tries. Overrides {TrieCompressor#compressed?}.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        @is_compressed = @is_compressed.nil? ? false : @is_compressed
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false` otherwise.
      def has_branch_for?(word = '')
        chars = word.chars.to_a
        compressed? ? has_compressed_branch_for?(chars) : has_uncompressed_branch_for?(chars)
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last character corresponds to a terminal node.
      def is_word?(word = '')
        chars = word.chars.to_a
        compressed? ? is_compressed_word?(chars) : is_uncompressed_word?(chars)
      end

      private
      def add_all_nodes
        File.open(@filename) do |file|
          while word = file.gets
            add_branch_from(word.chomp)
          end
        end
      end
    end
  end
end
