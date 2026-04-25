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
        # @param [Array<Symbol>] _word the word chars to add to the trie.
        # @param [Object, nil] _value the value to associate with the word.
        # @raise [InvalidOperation] if the trie is already compressed.
        # @return [void]
        def add _word, _value = nil
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
            return false unless child_letter == letter

            child.partial_word? chars
          else
            child_letter.start_with? chars.join
          end
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

          if chars.size < child_letter.size
            return child_letter.start_with?(chars.join) ? child : missing
          end

          letter = (chars.shift(child_letter.size) || raise).join
          return missing unless child_letter == letter

          child.scan chars
        end

        def children_match_prefix chars
          return enum_for :children_match_prefix, chars unless block_given?

          return empty_enum if chars.empty?

          child = children_tree[(chars.first || raise).to_sym]
          return empty_enum unless child

          match_child_prefix(child, chars) { |word| yield word }
        end

        def match_child_prefix child, chars
          child_letter = child.letter.to_s

          # stop early if we already know that the remaining characters in the
          # given phrase do not even cover the current node's compressed key
          return empty_enum if chars.size < child_letter.size

          letter = (chars.shift(child_letter.size) || raise).join

          return empty_enum unless child_letter == letter

          child.match_prefix(chars) { |word| yield word }
        end
      end
    end
  end
end
