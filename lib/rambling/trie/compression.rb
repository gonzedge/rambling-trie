module Rambling
  module Trie
    # Provides the compressing behavior for the Trie data structure.
    module Compression
      # Indicates if the current [Rambling::Trie::Node] can be compressed.
      # @return [Boolean] `true` for non-terminal nodes with one child,
      # `false` otherwise.
      def compressable?
        !(root? || terminal?) && children_tree.size == 1
      end
    end
  end
end
