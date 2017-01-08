module Rambling
  module Trie
    # Provides the to_s behavior for the Trie data structure.
    module Stringifyable
      # String representation of the current node, if it is a terminal node.
      # @return [String] the string representation of the current node.
      # @raise [InvalidOperation] if node is not terminal or is root.
      def as_word
        raise Rambling::Trie::InvalidOperation, 'Cannot represent branch as a word' if letter && !terminal?
        to_s
      end

      # String representation of the current node.
      # @return [String] the string representation of the current node.
      def to_s
        parent.to_s << letter.to_s
      end
    end
  end
end
