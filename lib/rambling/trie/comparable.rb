# frozen_string_literal: true

module Rambling
  module Trie
    # Provides the comparable behavior for the trie data structure.
    module Comparable
      # Compares two nodes.
      # @param [Nodes::Node] other the node to compare against.
      # @return [Boolean] +true+ if the nodes' {Nodes::Node#letter #letter} and
      #   {Nodes::Node#children_tree #children_tree} are equal, +false+ otherwise.
      def == other
        letter == other.letter &&
          terminal? == other.terminal? &&
          children_tree == other.children_tree
      end
    end
  end
end
