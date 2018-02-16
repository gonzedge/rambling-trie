module Rambling
  module Trie
    # Wrapper on top of trie data structure.
    class Container
      include ::Enumerable

      # The root node of this trie.
      # @return [Nodes::Node] the root node of this trie.
      attr_reader :root

      # Creates a new trie.
      # @param [Nodes::Node] root the root node for the trie
      # @param [Compressor] compressor responsible for compressing the trie
      # @yield [Container] the trie just created.
      def initialize root, compressor
        @root = root
        @compressor = compressor

        yield self if block_given?
      end

      # Adds a word to the trie, without altering the passed word.
      # @param [String] word the word to add the branch from.
      # @return [Nodes::Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see Nodes::Raw#add
      # @see Nodes::Compressed#add
      # @note Avoids altering the contents of the word variable.
      def add word
        root.add char_symbols word
      end

      # Compresses the existing tree using redundant node elimination. Marks
      # the trie as compressed.
      # @return [Container] self
      # @note Only compresses tries that have not already been compressed.
      def compress!
        self.root = compressor.compress root unless root.compressed?
        self
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false`
      #   otherwise.
      # @see Nodes::Raw#partial_word?
      # @see Nodes::Compressed#partial_word?
      def partial_word? word = ''
        root.partial_word? word.chars
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last
      #   character corresponds to a terminal node, `false` otherwise.
      # @see Nodes::Raw#word?
      # @see Nodes::Compressed#word?
      def word? word = ''
        root.word? word.chars
      end

      # Returns all words that start with the specified characters.
      # @param [String] word the word to look for in the trie.
      # @return [Array<String>] all the words contained in the trie that start
      #   with the specified characters.
      # @see Nodes::Raw#scan
      # @see Nodes::Compressed#scan
      def scan word = ''
        root.scan(word.chars).to_a
      end

      # Returns all words within a string that match a word contained in the
      # trie.
      # @param [String] phrase the string to look for matching words in.
      # @return [Enumerator<String>] all the words in the given string that
      #   match a word in the trie.
      # @yield [String] each word found in phrase.
      # @see Nodes::Node#words_within
      def words_within phrase
        words_within_root(phrase).to_a
      end

      # Checks if there are any valid words in a given string.
      # @param [String] phrase the string to look for matching words in.
      # @return [Boolean] `true` if any word within phrase is contained in the
      #   trie, `false` otherwise.
      # @see Container#words_within
      def words_within? phrase
        words_within_root(phrase).any?
      end

      # Compares two trie data structures.
      # @param [Container] other the trie to compare against.
      # @return [Boolean] `true` if the tries are equal, `false` otherwise.
      def == other
        root == other.root
      end

      # Iterates over the words contained in the trie.
      # @yield [String] the words contained in this trie node.
      def each
        return enum_for :each unless block_given?

        root.each do |word|
          yield word
        end
      end

      # @return [String] a string representation of the container.
      def inspect
        "#<#{self.class.name} root: #{root.inspect}>"
      end

      # Get {Nodes::Node Node} corresponding to a given letter.
      # @param [Symbol] letter the letter to search for in the root node.
      # @return [Nodes::Node] the node corresponding to that letter.
      # @see Nodes::Node#[]
      def [] letter
        root[letter]
      end

      # Root node's child nodes.
      # @return [Array<Nodes::Node>] the array of children nodes contained in
      #   the root node.
      # @see Nodes::Node#children
      def children
        root.children
      end

      # Root node's children tree.
      # @return [Array<Nodes::Node>] the array of children nodes contained in
      #   the root node.
      # @see Nodes::Node#children_tree
      def children_tree
        root.children_tree
      end

      # Indicates if the root {Nodes::Node Node} can be
      # compressed or not.
      # @return [Boolean] `true` for non-{Nodes::Node#terminal? terminal}
      #    nodes with one child, `false` otherwise.
      def compressed?
        root.compressed?
      end

      # Array of words contained in the root {Nodes::Node Node}.
      # @return [Array<String>] all words contained in this trie.
      # @see https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-to_a
      #   Enumerable#to_a
      def to_a
        root.to_a
      end

      # Check if a letter is part of the root {Nodes::Node}'s children tree.
      # @param [Symbol] letter the letter to search for in the root node.
      # @return [Boolean] whether the letter is contained or not.
      # @see Nodes::Node#has_key?
      def has_key? letter
        root.has_key? letter
      end

      # Size of the Root {Nodes::Node Node}'s children tree.
      # @return [Integer] the number of letters in the root node.
      def size
        root.size
      end

      # String representation of the current node, if it is a terminal node.
      # @return [String] the string representation of the current node.
      # @raise [InvalidOperation] if node is not terminal or is root.
      # @deprecated This will always raise an {InvalidOperation} exception.
      def as_word
        warn '[DEPRECATION WARNING] `#as_word` is deprecated. Please use `#root#as_word` instead.'
        root.as_word
      end

      # Root {Nodes::Node Node}'s letter.
      # @return [Symbol] the root node's letter
      # @see Nodes::Node#letter
      # @deprecated This will always return `nil`.
      def letter
        warn '[DEPRECATION WARNING] `#letter` is deprecated. Please use `#root#letter` instead.'
        root.letter
      end

      # Root {Nodes::Node Node}'s parent.
      # @return [Symbol] the root node's parent
      # @see Nodes::Node#parent
      # @deprecated This will always return `nil`.
      def parent
        warn '[DEPRECATION WARNING] `#parent` is deprecated. Please use `#root#parent` instead.'
        root.parent
      end

      # String representation of root {Nodes::Node Node}.
      # @return [String] the root node's string representation.
      # @see Stringifyable#to_s
      # @deprecated This will always return an empty string (`''`).
      def to_s
        warn '[DEPRECATION WARNING] `#to_s` is deprecated. Please use `#root#to_s` instead.'
        root.to_s
      end

      alias_method :include?, :word?
      alias_method :match?, :partial_word?
      alias_method :words, :scan
      alias_method :<<, :add
      alias_method :has_letter?, :has_key?

      private

      attr_reader :compressor
      attr_writer :root

      def words_within_root phrase
        return enum_for :words_within_root, phrase unless block_given?

        chars = phrase.chars
        0.upto(chars.length - 1).each do |starting_index|
          new_phrase = chars.slice starting_index..(chars.length - 1)
          root.match_prefix new_phrase do |word|
            yield word
          end
        end
      end

      def char_symbols word
        symbols = []
        word.reverse.each_char { |c| symbols << c.to_sym }
        symbols
      end
    end
  end
end
