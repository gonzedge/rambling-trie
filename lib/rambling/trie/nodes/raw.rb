module Rambling
  module Trie
    module Nodes
      # A representation of a node in an uncompressed trie data structure.
      class Raw < Rambling::Trie::Nodes::Node
        # Adds a word to the current raw (uncompressed) trie node.
        # @param [String] word the word to add to the trie.
        # @return [Raw] the added/modified node based on the word added.
        # @note This method clears the contents of the word variable.
        def add word
          if word.empty?
            terminal!
          else
            add_to_children_tree word
          end
        end

        # Checks if a path for a set of characters exists in the trie.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Boolean] `true` if the characters are found, `false`
        #   otherwise.
        def partial_word? chars = []
          return true if chars.empty?

          letter = chars.slice!(0).to_sym
          child = children_tree[letter]
          !!child && child.partial_word?(chars)
        end

        # Checks if a path for set of characters represents a word in the trie.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Boolean] `true` if the characters are found and form a word,
        #   `false` otherwise.
        def word? chars = []
          return terminal? if chars.empty?

          letter = chars.slice!(0).to_sym
          child = children_tree[letter]
          !!child && child.word?(chars)
        end

        # Always return `false` for a raw (uncompressed) node.
        # @return [Boolean] always `false` for a raw (uncompressed) node.
        def compressed?
          false
        end

        private

        def add_to_children_tree word
          letter = word.slice!(0)
          child = children_tree[letter] || new_node(letter)
          child.add word
          child
        end

        def new_node letter
          node = Rambling::Trie::Nodes::Raw.new self
          node.letter = letter
          children_tree[letter] = node
        end

        def closest_node chars
          letter = chars.slice!(0).to_sym
          child = children_tree[letter]

          return Rambling::Trie::Nodes::Missing.new unless child

          child.scan chars
        end

        def children_match_prefix chars
          return enum_for :children_match_prefix, chars unless block_given?

          return if chars.empty?

          letter = chars.slice!(0).to_sym
          child = children_tree[letter]

          return unless child

          child.match_prefix chars do |word|
            yield word
          end
        end
      end
    end
  end
end
