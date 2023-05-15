# frozen_string_literal: true

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
        # :reek:FeatureEnvy
        Rambling::Trie::Nodes::Compressed.new letter.to_sym, node.parent, other.children_tree, other.terminal?
      end

      def compress_children_and_copy node
        children_tree = compress_children node.children_tree
        # :reek:FeatureEnvy
        Rambling::Trie::Nodes::Compressed.new node.letter, node.parent, children_tree, node.terminal?
      end

      def compress_children tree
        new_tree = {}
        tree.each { |letter, child| new_tree[letter] = compress child }
        new_tree
      end
    end
  end
end
