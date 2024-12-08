# frozen_string_literal: true

module Rambling
  module Trie
    # Responsible for the compression process of a trie data structure.
    class Compressor
      # Compresses a {Nodes::Node Node} from a trie data structure.
      # @param [Nodes::Node, nil] node the node to compress.
      # @return [Nodes::Compressed, nil] node the compressed version of the node.
      def compress node
        return unless node

        if node.compressible?
          compress_only_child_and_merge node
        else
          compress_children_and_copy node
        end
      end

      private

      # Compresses a {Nodes::Node Node} with an only child from a trie data structure.
      # By this point we already know the node is not nil and that it has an only child,
      # so we use the type annotation because compressed_child will always have a value.
      # @see Rambling::Trie::Compressible#compressible? Compressible#compressible?
      # @param [Nodes::Node] node the node to compress.
      # @return [Nodes::Compressed] node the compressed version of the node.
      def compress_only_child_and_merge node
        compressed_child = compress(node.first_child) # : Nodes::Compressed
        merge node, compressed_child
      end

      def merge node, other
        letter = node.letter.to_s << other.letter.to_s

        compressed = Rambling::Trie::Nodes::Compressed.new letter.to_sym, node.parent, other.children_tree
        if other.terminal?
          compressed.terminal!
          value = other.value
          compressed.value = value if value
        end
        compressed
      end

      def compress_children_and_copy node
        children_tree = compress_children(node.children_tree)
        compressed = Rambling::Trie::Nodes::Compressed.new node.letter, node.parent, children_tree
        if node.terminal?
          compressed.terminal!
          value = node.value
          compressed.value = value if value
        end
        compressed
      end

      def compress_children tree
        new_tree = {}

        tree.each { |letter, child| new_tree[letter] = compress child }

        new_tree
      end
    end
  end
end
