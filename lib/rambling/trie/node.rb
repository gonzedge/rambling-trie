module Rambling
  module Trie
    # A representation of a node in the Trie data structure.
    class Node
      extend Rambling::Trie::Forwardable
      include Rambling::Trie::Compression
      include Rambling::Trie::Enumerable
      include Rambling::Trie::Inspector

      delegate [
        :[],
        :[]=,
        :delete,
        :has_key?
      ] => :children_tree

      # Letter or letters corresponding to this node.
      # @return [Symbol, nil] the corresponding letter(s) or nil.
      attr_reader :letter

      # Children nodes.
      # @return [Hash] the children_tree hash, consisting of :letter => node.
      attr_accessor :children_tree

      # Parent node.
      # @return [Node, nil] the parent node or nil for the root element.
      attr_accessor :parent

      # Creates a new Node.
      # @param [Node, nil] parent the parent of this node.
      def initialize parent = nil
        self.parent = parent
        self.children_tree = {}
      end

      # String representation of the current node, if it is a terminal node.
      # @return [String] the string representation of the current node.
      # @raise [InvalidOperation] if node is not terminal or is root.
      def as_word
        raise InvalidOperation, 'Cannot represent branch as a word' if letter && !terminal?
        to_s
      end

      # Children nodes of the current node.
      # @return [Array] the array of children nodes contained in the current node.
      def children
        children_tree.values
      end

      # If the current node is the root node.
      # @return [Boolean] `true` only if the node does not have a parent
      def root?
        !parent
      end

      # Flag for terminal nodes.
      # @return [Boolean] `true` for terminal nodes, `false` otherwise.
      def terminal?
        !!terminal
      end

      # Force [Node] to be `terminal`
      # @return [Node] the modified node.
      def terminal!
        self.terminal = true
        self
      end

      # String representation of the current node.
      # @return [String] the string representation of the current node.
      def to_s
        parent.to_s << letter.to_s
      end

      def letter= letter
        if letter
          @letter = letter.to_sym
          parent[letter] = self if parent
        end
      end

      private

      attr_accessor :terminal
    end
  end
end
