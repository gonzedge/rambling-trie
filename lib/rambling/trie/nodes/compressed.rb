# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a node in a compressed trie data structure.
      # :reek:RepeatedConditional { max_ifs: 4 }
      class Compressed < Rambling::Trie::Nodes::Node
        # Creates a new compressed node.
        # @param [Symbol, nil] letter the Node's letter value.
        # @param [Node, nil] parent the parent of the current node.
        # @param [Hash<Symbol, Node>] children_tree the children tree of the current node.
        def initialize letter = nil, parent = nil, children_tree = {}
          super

          # Ensure all children have the current compressed node as the parent
          children_tree.each_value { |child| child.parent = self }
        end

        # Always raises {Rambling::Trie::InvalidOperation InvalidOperation} when
        # trying to add a word to the current compressed trie node
        # @param [String] _ the word to add to the trie.
        # @raise [InvalidOperation] if the trie is already compressed.
        # @return [void]
        def add _, _ = nil
          raise Rambling::Trie::InvalidOperation, 'Cannot add word to compressed trie'
        end

        # Always return `true` for a compressed node.
        # @return [Boolean] always `true` for a compressed node.
        def compressed?
          true
        end

        private

        def partial_word_chars? chars
          child = children_tree[(chars.first || raise).to_sym]
          return false unless child

          child_letter = child.letter.to_s

          if chars.size >= child_letter.size
            letter = (chars.shift(child_letter.size) || raise).join
            return child.partial_word? chars if child_letter == letter
          end

          letter = chars.join
          child_letter = child_letter.slice 0, letter.size
          child_letter == letter
        end

        def word_chars? chars
          letter = chars.shift || raise
          letter_sym = letter.to_sym

          child = children_tree[letter_sym]
          return false unless child

          loop do
            return child.word? chars if letter_sym == child.letter

            break if chars.empty?

            letter << (chars.shift || raise)
            letter_sym = letter.to_sym
          end

          false
        end

        def closest_node chars
          child = children_tree[(chars.first || raise).to_sym]
          return missing unless child

          child_letter = child.letter.to_s

          if chars.size >= child_letter.size
            letter = (chars.shift(child_letter.size) || raise).join
            return child.scan chars if child_letter == letter
          end

          letter = chars.join
          child_letter = child_letter.slice 0, letter.size

          child_letter == letter ? child : missing
        end

        def children_match_prefix chars
          return enum_for :children_match_prefix, chars unless block_given?

          return EMPTY_ENUMERATOR if chars.empty?

          child = children_tree[(chars.first || raise).to_sym]
          return EMPTY_ENUMERATOR unless child

          child_letter = child.letter.to_s
          letter = (chars.shift(child_letter.size) || raise).join

          return EMPTY_ENUMERATOR unless child_letter == letter

          child.match_prefix(chars) { |word| yield word }
        end
      end
    end
  end
end
