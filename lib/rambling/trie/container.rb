module Rambling
  module Trie
    class Container
      extend ::Forwardable

      include ::Enumerable

      delegate [
        :each,
        :compressed?
      ] => :root

      # Creates a new Trie.
      # @param [Node] root the root node for the trie
      # @param [Compressor] compressor responsible for compressing the trie
      # @yield [Container] the trie just created.
      def initialize root = nil, compressor = nil
        @root = root || default_root
        @compressor = compressor || default_compressor

        yield self if block_given?
      end

      # Adds a branch to the trie based on the word, without changing the passed word.
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see Branches#add
      # @note Avoids clearing the contents of the word variable.
      def add word
        root.add word.clone
      end

      # Compresses the existing tree using redundant node elimination. Flags the trie as compressed.
      # @return [Container] self
      def compress!
        self.root = compressor.compress root
        self
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false` otherwise.
      def partial_word? word = ''
        root.partial_word? word.chars.to_a
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last character corresponds to a terminal node.
      def word? word = ''
        root.word? word.chars.to_a
      end

      # Returns all words that start with the specified characters.
      # @param [String] word the word to look for in the trie.
      # @return [Array] all the words contained in the trie that start with the specified characters.
      def scan word = ''
        root.scan word
      end

      alias_method :include?, :word?
      alias_method :match?, :partial_word?
      alias_method :words, :scan
      alias_method :<<, :add

      private

      attr_reader :compressor
      attr_accessor :root

      def default_root
        Rambling::Trie::Raw::Node.new
      end

      def default_compressor
        Rambling::Trie::Compressor.new
      end
    end
  end
end
