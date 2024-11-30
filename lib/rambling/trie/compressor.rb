# frozen_string_literal: true

module Rambling
  module Trie
    # Responsible for the compression process of a trie data structure.
    class Compressor
      # Compresses a {Nodes::Node Node} from a trie data structure.
      # @param [Nodes::Node] node the node to compress.
      # @return [Nodes::Compressed] node the compressed version of the node.
      def compress node
        return unless node

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
        letter = node.letter
        parent = node.parent

        if other
          letter = letter.to_s << other.letter.to_s
          compressed = Rambling::Trie::Nodes::Compressed.new letter.to_sym, parent, other.children_tree
          terminal = other.terminal?
        else
          compressed = Rambling::Trie::Nodes::Compressed.new letter, parent, node.children_tree
          terminal = node.terminal?
        end

        compressed.terminal! if terminal
        compressed
      end

      def compress_children_and_copy node
        children_tree = compress_children(node.children_tree)
        compressed = Rambling::Trie::Nodes::Compressed.new node.letter, node.parent, children_tree
        compressed.terminal! if node.terminal?
        compressed
      end

      def compress_children tree
        new_tree = {}

        tree.each do |letter, child|
          compressed_child = compress child
          new_tree[letter] = compressed_child
        end

        new_tree
      end
    end
  end
end
