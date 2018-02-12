module Rambling
  module Trie
    # Responsible for the compression process of a trie data structure.
    class Compressor
      # Compresses a {Node Node} from a trie data structure.
      # @param [RawNode] node the node to compress.
      # @return [CompressedNode] node the compressed version of the node.
      def compress node
        if node.compressable?
          merge_with_child_and_compress node
        else
          copy_node_and_compress_children node
        end
      end

      private

      def merge_with_child_and_compress node
        child = node.first_child

        letter = node.letter.to_s << child.letter.to_s
        new_node = new_compressed_node node, letter, child.terminal?
        new_node.children_tree = child.children_tree

        compress new_node
      end

      def copy_node_and_compress_children node
        new_node = new_compressed_node node, node.letter, node.terminal?

        node.children_tree.each_value do |child|
          compressed_child = compress child

          compressed_child.parent = new_node
          new_node[compressed_child.letter] = compressed_child
        end

        new_node
      end

      def new_compressed_node node, letter, terminal
        new_node = Rambling::Trie::CompressedNode.new node.parent
        new_node.letter = letter
        new_node.terminal! if terminal
        new_node
      end
    end
  end
end
