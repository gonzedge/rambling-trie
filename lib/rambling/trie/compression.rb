module Rambling
  module Trie
    # Provides the compressing behavior for the Trie data structure.
    module Compression
      # Flag for compressed tries.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        parent && parent.compressed?
      end

      # Compress the current node using redundant node elimination.
      # @return [Root, Node] the compressed node.
      def compress_tree!
        if compressable?
          merge_with! children.first
          compress_tree!
        end

        children.each &:compress_tree!

        self
      end

      private

      def compressable?
        !(root? || terminal?) && children_tree.size == 1
      end

      def merge_with! child
        delete_old_key_on_parent!
        redefine_self! child

        children.each { |node| node.parent = self }
      end

      def delete_old_key_on_parent!
        parent.delete letter if parent
      end

      def redefine_self! merged_node
        self.letter = letter.to_s << merged_node.letter.to_s
        self.children_tree = merged_node.children_tree
        self.terminal = merged_node.terminal?
      end
    end
  end
end
