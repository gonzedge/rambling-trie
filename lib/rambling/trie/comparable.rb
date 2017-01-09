module Rambling
  module Trie
    # Provides the comparable behavior for the trie data structure.
    module Comparable
      # Compares two nodes.
      # @param [Node] other the node to compare against.
      # @return [Boolean] `true` if the nodes' {Node#letter #letter} and
      #   {Node#children_tree #children_tree} are equal, `false` otherwise.
      def == other
        letter == other.letter &&
          terminal? == other.terminal? &&
          children_tree == other.children_tree
      end
    end
  end
end
