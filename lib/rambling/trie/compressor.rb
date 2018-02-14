module Rambling
  module Trie
    # Responsible for the compression process of a trie data structure.
    class Compressor
      # Compresses a {Nodes::Node Node} from a trie data structure.
      # @param [Nodes::Raw] node the node to compress.
      # @return [Nodes::Compressed] node the compressed version of the node.
      def compress node
        if node.compressible?
          compress_child_and_merge node
        else
          compress_children_and_copy node
        end
      end

      private

      def compress_child_and_merge node
        merge node, compress(node.first_child)
      end

      def merge node, other
        letter = node.letter.to_s << other.letter.to_s

        new_compressed_node(
          letter.to_sym,
          node.parent,
          other.children_tree,
          other.terminal?
        )
      end

      def compress_children_and_copy node
        new_compressed_node(
          node.letter,
          node.parent,
          compress_children(node.children_tree),
          node.terminal?
        )
      end

      def compress_children children_tree
        new_children_tree = {}

        children_tree.each_value do |child|
          compressed_child = compress child
          new_children_tree[compressed_child.letter] = compressed_child
        end

        new_children_tree
      end

      def new_compressed_node letter, parent, children_tree, terminal
        node = Rambling::Trie::Nodes::Compressed.new letter, parent, children_tree
        node.terminal! if terminal

        children_tree.each_value { |child| child.parent = node }
        node
      end
    end
  end
end
