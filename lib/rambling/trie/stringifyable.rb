module Rambling
  module Trie
    # Provides the to_s behavior for the Trie data structure.
    module Stringifyable
      # String representation of the current node.
      # @return [String] the string representation of the current node.
      def to_s
        parent.to_s << letter.to_s
      end
    end
  end
end
