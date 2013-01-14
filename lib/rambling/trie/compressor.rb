module Rambling
  module Trie
    # Provides the compressing behavior for the Trie data structure.
    module Compressor
      # Flag for compressed tries.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        parent && parent.compressed?
      end

      # Compress the current node using redundant node elimination.
      # @return [Root, Node] the compressed node.
      def compress_tree!
        if children.size == 1 && !terminal? && letter
          merge_with! children.values.first
          compress_tree!
        end

        children.values.each &:compress_tree!

        self
      end

      private

      def merge_with!(child)
        delete_old_key_on_parent!
        redefine_self! child

        children.each { |_, node| node.parent = self }
      end

      def delete_old_key_on_parent!
        return if parent.nil?

        parent.delete letter
      end

      def redefine_self!(merged_node)
        self.letter = letter.to_s << merged_node.letter.to_s
        self.children = merged_node.children
        self.terminal = merged_node.terminal?
      end
    end
  end
end
