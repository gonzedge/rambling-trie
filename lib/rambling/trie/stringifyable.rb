# frozen_string_literal: true

module Rambling
  module Trie
    # Provides the String representation behavior for the trie data structure.
    module Stringifyable
      # String representation of the current node, if it is a terminal node.
      # @return [String] the string representation of the current node.
      # @raise [InvalidOperation] if node is not terminal or is root.
      def as_word
        if letter && !terminal?
          raise Rambling::Trie::InvalidOperation,
            'Cannot represent branch as a word'
        end

        to_s
      end

      # String representation of the current node.
      # @return [String] the string representation of the current node.
      def to_s
        parent.to_s + letter.to_s
      end
    end
  end
end
