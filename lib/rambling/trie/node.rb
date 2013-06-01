module Rambling
  module Trie
    # A representation of a node in the Trie data structure.
    class Node
      extend Forwardable

      delegate [:[], :[]=, :delete, :has_key?] => :children_tree

      include Compressor
      include Branches
      include Enumerable
      include Inspector

      # Letter or letters corresponding to this node.
      # @return [Symbol, nil] the corresponding letter(s) or nil.
      attr_reader :letter

      # Children nodes.
      # @return [Hash] the children_tree hash, consisting of :letter => node.
      attr_reader :children_tree

      # Parent node.
      # @return [Node, nil] the parent node or nil for the root element.
      attr_accessor :parent

      # Creates a new Node.
      # @param [String, nil] word the word from which to create this Node and his branch.
      # @param [Node, nil] parent the parent of this node.
      def initialize word = nil, parent = nil
        self.parent = parent
        self.children_tree = {}

        unless word.nil? || word.empty?
          self.letter = word.slice! 0
          self.terminal = word.empty?
          self << word
        end
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
      # @return [Boolean] `false`
      def root?
        false
      end

      # Flag for terminal nodes.
      # @return [Boolean] `true` for terminal nodes, `false` otherwise.
      def terminal?
        !!terminal
      end

      # String representation of the current node.
      # @return [String] the string representation of the current node.
      def to_s
        parent.to_s << letter.to_s
      end

      protected

      attr_writer :children_tree
      attr_accessor :terminal

      def letter= new_letter
        if new_letter
          @letter = new_letter.to_sym
          parent[letter] = self if parent
        end
      end
    end
  end
end
