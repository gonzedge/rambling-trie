module Rambling
  module Trie
    # Provides the compressable behavior for the Trie data structure.
    module Compressable
      # Indicates if the current {Rambling::Trie::Node Node} can be compressed
      # or not.
      # @return [Boolean] `true` for non-{Node#terminal? terminal} nodes with
      #   one child, `false` otherwise.
      def compressable?
        !(root? || terminal?) && children_tree.size == 1
      end
    end
  end
end
