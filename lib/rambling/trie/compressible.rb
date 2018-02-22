# frozen_string_literal: true

module Rambling
  module Trie
    # Provides the compressible behavior for the trie data structure.
    module Compressible
      # Indicates if the current {Rambling::Trie::Nodes::Node Node} can be
      # compressed or not.
      # @return [Boolean] `true` for non-{Nodes::Node#terminal? terminal} nodes
      #   with one child, `false` otherwise.
      def compressible?
        !(root? || terminal?) && children_tree.size == 1
      end
    end
  end
end
