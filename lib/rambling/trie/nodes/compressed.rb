# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a node in an compressed trie data structure.
      class Compressed < Rambling::Trie::Nodes::Node
        # Always raises {Rambling::Trie::InvalidOperation InvalidOperation} when
        # trying to add a word to the current compressed trie node
        # @param [String] _ the word to add to the trie.
        # @raise [InvalidOperation] if the trie is already compressed.
        # @return [void]
        def add _
          raise Rambling::Trie::InvalidOperation, 'Cannot add word to compressed trie'
        end

        # Always return +true+ for a compressed node.
        # @return [Boolean] always +true+ for a compressed node.
        def compressed?
          true
        end

        private

        def partial_word_chars? chars
          child = children_tree[chars.first.to_sym]
          return false unless child

          child_letter = child.letter.to_s

          if chars.size >= child_letter.size
            letter = chars.slice!(0, child_letter.size).join
            return child.partial_word? chars if child_letter == letter
          end

          letter = chars.join
          child_letter = child_letter.slice 0, letter.size
          child_letter == letter
        end

        def word_chars? chars
          letter = chars.slice! 0
          letter_sym = letter.to_sym

          child = children_tree[letter_sym]
          return false unless child

          loop do
            return child.word? chars if letter_sym == child.letter

            break if chars.empty?

            letter << chars.slice!(0)
            letter_sym = letter.to_sym
          end

          false
        end

        def closest_node chars
          child = children_tree[chars.first.to_sym]
          return missing unless child

          child_letter = child.letter.to_s

          if chars.size >= child_letter.size
            letter = chars.slice!(0, child_letter.size).join
            return child.scan chars if child_letter == letter
          end

          letter = chars.join
          child_letter = child_letter.slice 0, letter.size

          child_letter == letter ? child : missing
        end

        def children_match_prefix chars
          return enum_for :children_match_prefix, chars unless block_given?

          return EMPTY_ENUMERATOR if chars.empty?

          child = children_tree[chars.first.to_sym]
          return EMPTY_ENUMERATOR unless child

          child_letter = child.letter.to_s
          letter = chars.slice!(0, child_letter.size).join

          return EMPTY_ENUMERATOR unless child_letter == letter

          child.match_prefix chars do |word|
            yield word
          end
        end
      end
    end
  end
end
