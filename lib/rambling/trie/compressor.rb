module Rambling
  module Trie
    # Provides the compressing behavior for the Trie data structure.
    module Compressor
      # Flag for compressed tries.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        parent and parent.compressed?
      end

      # Compress the current node using redundant node elimination.
      # @return [Root, Node] the compressed node.
      def compress_tree!
        if children.size == 1 and not terminal? and letter
          merge_with! children.values.first
          compress_tree!
        end

        children.values.each &:compress_tree!

        self
      end

      private

      def merge_with!(child)
        new_letter = (letter.to_s << child.letter.to_s).to_sym

        rehash_on_parent! letter, new_letter
        redefine_self! new_letter, child

        children.values.each { |node| node.parent = self }
      end

      def rehash_on_parent!(old_letter, new_letter)
        return if parent.nil?

        parent.delete old_letter
        parent[new_letter] = self
      end

      def redefine_self!(new_letter, merged_node)
        self.letter = new_letter
        self.children = merged_node.children
        self.terminal = merged_node.terminal?
      end
    end
  end
end
