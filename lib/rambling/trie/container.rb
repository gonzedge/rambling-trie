# frozen_string_literal: true

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
      # @yield [self] the trie just initialized.
      def initialize root, compressor
        @root = root
        @compressor = compressor

        yield self if block_given?
      end

      # Adds a word to the trie.
      # @param [String] word the word to add to the trie.
      # @param [Object, nil] value the value to associate with the word.
      # @return [Nodes::Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see Nodes::Raw#add
      # @see Nodes::Compressed#add
      def add word, value = nil
        root.add reversed_char_symbols(word), value
      end

      # Adds all provided words to the trie.
      # @param [Array<String>] words the words to add to the trie.
      # @param [Array<Object>, nil] values the values to associate with each word, in the same order.
      # @return [Array<Nodes::Node>] the collection of nodes added.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @raise [ArgumentError] if words and values are given but differ in size.
      # @see Nodes::Raw#add
      # @see Nodes::Compressed#add
      def concat words, values = nil
        if values
          words_size = words.size
          values_size = values.size
          unless words_size == values_size
            raise ArgumentError,
              "words and values must have the same size (words: #{words_size}, values: #{values_size})"
          end

          words.each_with_index.map { |word, index| add(word, values[index]) }
        else
          words.map { |word| add word }
        end
      end

      # Compresses the existing trie using redundant node elimination.
      # Marks the trie as compressed.
      # Does nothing if the trie has already been compressed.
      # @return [self]
      # @note This method replaces the root {Nodes::Raw Raw} node with a {Nodes::Compressed Compressed} version of it.
      def compress!
        self.root = compress_root unless root.compressed?
        self
      end

      # Compresses the existing trie using redundant node elimination. Returns a new trie with the compressed root.
      # @return [Container] A new {Container} with the {Nodes::Compressed Compressed} root node.
      # @deprecated Calling {#compress} on an already-compressed trie is deprecated and will raise
      #   {InvalidOperation} in the next major version. Use {#compressed?} to guard if needed.
      def compress
        if root.compressed?
          warn <<~WARN.chomp.tr("\n", ' ')
            [DEPRECATED] Calling `compress` on an already-compressed trie is deprecated
            and will raise `InvalidOperation` in the next major version.
            Called from #{caller_locations(1, 1)&.first}
          WARN
          return Rambling::Trie::Container.new root, compressor
        end

        Rambling::Trie::Container.new compress_root, compressor
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false` otherwise.
      # @see Nodes::Node#partial_word?
      def partial_word? word = ''
        root.partial_word? word.chars
      end

      # Adds all provided words to the trie.
      # @param [String] words the words to add to the trie.
      # @return [Array<Nodes::Node>] the collection of nodes added.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see #concat
      # @see Nodes::Raw#add
      # @see Nodes::Compressed#add
      def push *words
        concat words
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last character corresponds to a terminal node,
      #   `false` otherwise.
      # @see Nodes::Node#word?
      def word? word = ''
        root.word? word.chars
      end

      # Returns all words that start with the specified characters.
      # @param [String] word the word to look for in the trie.
      # @return [Array<String>] all the words contained in the trie that start with the specified characters.
      # @see Nodes::Node#scan
      def scan word = ''
        root.scan(word.chars).to_a
      end

      # Returns all words within a string that match a word contained in the trie.
      # @param [String] phrase the string to look for matching words in.
      # @return [Array<String>] all the words in the given string that match a word in the trie.
      def words_within phrase
        words_within_root(phrase).to_a
      end

      # Checks if there are any valid words in a given string.
      # @param [String] phrase the string to look for matching words in.
      # @return [Boolean] `true` if any word within phrase is contained in the trie, `false` otherwise.
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
      # @return [self]
      def each
        return enum_for :each unless block_given?

        root.each { |word| yield word }

        self
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
      # @return [Array<Nodes::Node>] the array of children nodes contained in the root node.
      # @see Nodes::Node#children
      def children
        root.children
      end

      # Root node's children tree.
      # @return [Hash<Symbol, Nodes::Node>] the children tree hash contained in the root node, consisting of
      #   `:letter => node`.
      # @see Nodes::Node#children_tree
      def children_tree
        root.children_tree
      end

      # Indicates if the root {Nodes::Node Node} can be compressed or not.
      # @return [Boolean] `true` for non-{Nodes::Node#terminal? terminal} nodes with one child, `false` otherwise.
      def compressed?
        root.compressed?
      end

      # Array of words contained in the root {Nodes::Node Node}.
      # @return [Array<String>] all words contained in this trie.
      # @see https://ruby-doc.org/3.3.0/Enumerable.html#method-i-to_a Enumerable#to_a
      def to_a
        root.to_a
      end

      # Check if a letter is part of the root {Nodes::Node}'s children tree.
      # @param [Symbol] letter the letter to search for in the root node.
      # @return [Boolean] whether the letter is contained or not.
      # @see Nodes::Node#key?
      def key? letter
        root.key? letter
      end

      # Number of words contained in the trie.
      # @return [Integer] the number of words stored in the trie.
      def size
        root.size
      end

      alias_method :include?, :word?
      alias_method :match?, :partial_word?
      alias_method :words, :scan
      alias_method :<<, :add
      alias_method :has_key?, :key?
      alias_method :has_letter?, :key?

      private

      attr_reader :compressor
      attr_writer :root

      def words_within_root phrase
        return enum_for :words_within_root, phrase unless block_given?

        chars = phrase.chars
        chars.each_index do |starting_index|
          new_phrase = chars[starting_index..] || raise
          root.match_prefix(new_phrase) { |word| yield word }
        end

        self
      end

      def compress_root
        compressor.compress(root) || raise
      end

      def reversed_char_symbols word
        # @type var chars: Array[String]
        chars = word.chars
        chars.reverse!
        chars.map(&:to_sym)
      end
    end
  end
end
