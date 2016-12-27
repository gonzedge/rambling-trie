module Rambling
  module Trie
    # A representation of a node in an uncompressed Trie data structure.
    class RawNode < Rambling::Trie::Node
      # Adds a branch to the current trie node based on the word
      # @param [String] word the word to add the branch from.
      # @return [Rambling::Trie::RawNode] the just added branch's root node.
      # @note This method clears the contents of the word variable.
      def add word
        if word.empty?
          terminal!
        else
          add_to_children_tree word
        end
      end

      # Checks if a path for set of characters exists in the trie.
      # @param [Array] chars the characters to look for in the trie.
      # @return [Boolean] `true` if the characters are found, `false` otherwise.
      def partial_word? chars = []
        if chars.empty?
          true
        else
          letter = chars.slice!(0).to_sym
          child = children_tree[letter]
          !!child && child.partial_word?(chars)
        end
      end

      # Checks if a path for set of characters represents a word in the trie.
      # @param [Array] chars the characters to look for in the trie.
      # @return [Boolean] `true` if the characters are found and form a word,
      # `false` otherwise.
      def word? chars = []
        if chars.empty?
          terminal?
        else
          letter = chars.slice!(0).to_sym
          child = children_tree[letter]
          !!child && child.word?(chars)
        end
      end

      # Returns all words that start with the specified characters.
      # @param [Array] chars the characters to look for in the trie.
      # @return [Array] all the words contained in the trie that start with the specified characters.
      def scan chars
        chars.empty? ? self : closest_node(chars)
      end

      # Always return `false` for a raw (uncompressed) node.
      # @return [Boolean] always false for a raw (uncompressed) node.
      def compressed?
        false
      end

      protected

      def closest_node chars
        letter = chars.slice!(0).to_sym
        child = children_tree[letter]

        child ? child.scan(chars) : Rambling::Trie::MissingNode.new
      end

      private

      def add_to_children_tree word
        letter = word.slice!(0).to_sym
        child = children_tree[letter] || new_node(letter)
        child.add word
        child
      end

      def new_node letter
        node = Rambling::Trie::RawNode.new self
        node.letter = letter
        children_tree[letter] = node
      end
    end
  end
end
