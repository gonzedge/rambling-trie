module Rambling
  module Trie
    # Responsible for the compression process of a Trie data structure.
    class Compressor
      # Compresses a node from a Trie data structure.
      # @param [RawNode] node the node to compress
      # @return [CompressedNode] node the compressed version of the node
      def compress node, parent = nil
        if node.compressable?
          merge_node_with_compressed_child node, parent
        else
          copy_node_and_compress_children node, parent
        end
      end

      private

      def merge_node_with_compressed_child node, parent
        compressed_child = compress node.children.first

        new_node = Rambling::Trie::CompressedNode.new parent
        new_node.letter = node.letter.to_s << compressed_child.letter.to_s
        new_node.terminal! if compressed_child.terminal?
        new_node.children_tree = compressed_child.children_tree

        new_node.children.each do |child|
          child.parent = new_node
        end

        new_node
      end

      def copy_node_and_compress_children node, parent
        new_node = Rambling::Trie::CompressedNode.new parent

        new_node.letter = node.letter
        new_node.terminal! if node.terminal?

        node.children.map do |child|
          compress child, new_node
        end

        new_node
      end
    end
  end
end
