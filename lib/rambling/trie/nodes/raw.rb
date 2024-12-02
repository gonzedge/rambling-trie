# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a node in an uncompressed trie data structure.
      # :reek:RepeatedConditional { max_ifs: 4 }
      class Raw < Rambling::Trie::Nodes::Node
        # Adds a word to the current raw (uncompressed) trie node.
        # @param [Array<Symbol>] reversed_chars the char array to add to the trie, in reverse order.
        # @return [Node] the added/modified node based on the word added.
        # @note This method clears the contents of the chars variable.
        def add reversed_chars
          if reversed_chars.empty?
            terminal! unless root?
            self
          else
            add_to_children_tree reversed_chars
          end
        end

        # Always return `false` for a raw (uncompressed) node.
        # @return [Boolean] always `false` for a raw (uncompressed) node.
        def compressed?
          false
        end

        private

        def add_to_children_tree chars
          letter = chars.pop || raise
          child = children_tree[letter] || new_node(letter)
          child.add chars
          child
        end

        def new_node letter
          node = Rambling::Trie::Nodes::Raw.new letter, self
          children_tree[letter] = node
          node
        end

        def partial_word_chars? chars = []
          letter = (chars.shift || raise).to_sym
          child = children_tree[letter]
          return false unless child

          child.partial_word? chars
        end

        def word_chars? chars = []
          letter = (chars.shift || raise).to_sym
          child = children_tree[letter]
          return false unless child

          child.word? chars
        end

        def closest_node chars
          letter = (chars.shift || raise).to_sym
          child = children_tree[letter]
          return missing unless child

          child.scan chars
        end

        def children_match_prefix chars
          return enum_for :children_match_prefix, chars unless block_given?

          return EMPTY_ENUMERATOR if chars.empty?

          child = children_tree[(chars.shift || raise).to_sym]
          return EMPTY_ENUMERATOR unless child

          child.match_prefix(chars) { |word| yield word }
        end
      end
    end
  end
end
