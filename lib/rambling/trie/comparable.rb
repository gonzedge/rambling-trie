module Rambling
  module Trie
    # Provides the comparable behavior for the Trie data structure.
    module Comparable
      # Compares two nodes.
      # @param [Node] other the node to compare against.
      # @return [Boolean] `true` if the nodes' `#letter`s and `#children_tree`s
      #   are equal, `false` otherwise
      def == other
        letter == other.letter && children_tree == other.children_tree
      end
    end
  end
end
