# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a node in an compressed trie data structure.
      # :reek:RepeatedConditional
      # :reek:TooManyStatements { max_statements: 10 }
      class Compressed < Rambling::Trie::Nodes::Node
        # Creates a new compressed node.
        # @param [Symbol, nil] letter the Node's letter value.
        # @param [Node, nil] parent the parent of the current node.
        # @param [Hash<Symbol, Node>] children_tree the tree of child nodes.
        # @param [Boolean, nil] terminal whether the node is terminal or not.
        def initialize letter = nil, parent = nil, children_tree = {}, terminal = nil
          super letter, parent, children_tree, terminal || nil
          children_tree.each_value { |child| child.parent = self }
        end

        # Always raises {Rambling::Trie::InvalidOperation InvalidOperation} when
        # trying to add a word to the current compressed trie node
        # @param [String] _ the word to add to the trie.
        # @raise [InvalidOperation] if the trie is already compressed.
        # @return [void]
        def add _
          raise Rambling::Trie::InvalidOperation,
            'Cannot add word to compressed trie'
        end

        # Always return +true+ for a compressed node.
        # @return [Boolean] always +true+ for a compressed node.
        def compressed?
          true
        end

        private

        # :reek:FeatureEnvy
        def partial_word_chars? chars
          child = children_tree[chars.first.to_sym]
          return false unless child

          child_letter = child.letter.to_s
          size = child_letter.size

          if chars.size >= size
            partial_letter = chars.shift(size).join
            return child.partial_word? chars if child_letter == partial_letter
          end

          full_letter = chars.join
          child_letter = child_letter.slice 0, full_letter.size
          child_letter == full_letter
        end

        # :reek:FeatureEnvy
        def word_chars? chars
          letter = chars.shift
          letter_sym = letter.to_sym

          child = children_tree[letter_sym]
          return false unless child

          # :reek:DuplicateMethodCall
          loop do
            return child.word? chars if letter_sym == child.letter

            break if chars.empty?

            letter << chars.shift
            letter_sym = letter.to_sym
          end

          false
        end

        # :reek:FeatureEnvy
        def closest_node chars
          child = children_tree[chars.first.to_sym]
          return missing unless child

          child_letter = child.letter.to_s
          size = child_letter.size

          if chars.size >= size
            partial_letter = chars.shift(size).join
            return child.scan chars if child_letter == partial_letter
          end

          full_letter = chars.join
          child_letter = child_letter.slice 0, full_letter.size

          child_letter == full_letter ? child : missing
        end

        def children_match_prefix chars
          return enum_for :children_match_prefix, chars unless block_given?

          return if chars.empty?

          child = children_tree[chars.first.to_sym]
          return unless child

          child_letter = child.letter.to_s
          letter = chars.shift(child_letter.size).join

          return unless child_letter == letter

          child.match_prefix chars do |word|
            yield word
          end
        end
      end
    end
  end
end
