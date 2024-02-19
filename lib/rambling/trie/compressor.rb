# frozen_string_literal: true

module Rambling
  module Trie
    # Responsible for the compression process of a trie data structure.
    class Compressor
      # Compresses a {Nodes::Node Node} from a trie data structure.
      # @param [Nodes::Node] node the node to compress.
      # @return [Nodes::Compressed] node the compressed version of the node.
      def compress node
        return if node.nil?

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
        if other.nil?
          return new_compressed_node node.letter, node.parent, node.children_tree, node.terminal?
        end

        letter = node.letter.to_s << other.letter.to_s
        new_compressed_node letter.to_sym, node.parent, other.children_tree, other.terminal?
      end

      def compress_children_and_copy node
        new_compressed_node node.letter, node.parent, compress_children(node.children_tree), node.terminal?
      end

      def compress_children tree
        new_tree = {}

        tree.each do |letter, child|
          compressed_child = compress child
          new_tree[letter] = compressed_child
        end

        new_tree
      end

      def new_compressed_node letter, parent, tree, terminal
        node = Rambling::Trie::Nodes::Compressed.new letter, parent, tree
        node.terminal! if terminal

        tree.each_value { |child| child.parent = node }
        node
      end
    end
  end
end
