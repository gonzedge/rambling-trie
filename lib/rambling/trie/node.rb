module Rambling
  module Trie
    # A representation of a node in the Trie data structure.
    class Node
      include ChildrenHashDeferer
      include Compressor
      include Branches
      include Enumerable
      include Inspector

      # Letter or letters corresponding to this node.
      # @return [Symbol, nil] the corresponding letter(s) or nil.
      attr_reader :letter

      # Children nodes.
      # @return [Hash] the children hash, consisting of :letter => node.
      attr_reader :children

      # Parent node.
      # @return [Node, nil] the parent node or nil for the root element.
      attr_accessor :parent

      # Creates a new Node.
      # @param [String, nil] word the word from which to create this Node and his branch.
      # @param [Node, nil] parent the parent of this node.
      def initialize(word = nil, parent = nil)
        self.parent = parent
        self.children = {}

        unless word.nil? || word.empty?
          self.letter = word.slice! 0
          self.terminal = word.empty?
          self << word
        end
      end

      # Flag for terminal nodes.
      # @return [Boolean] `true` for terminal nodes, `false` otherwise.
      def terminal?
        !!terminal
      end

      # String representation of the current node, if it is a terminal node.
      # @return [String] the string representation of the current node.
      # @raise [InvalidOperation] if node is not terminal or is root.
      def as_word
        raise InvalidOperation, 'Cannot represent branch as a word' if letter && !terminal?
        to_s
      end

      # String representation of the current node.
      # @return [String] the string representation of the current node.
      def to_s
        parent.to_s << letter.to_s
      end

      protected

      attr_writer :children
      attr_accessor :terminal

      def letter=(letter)
        return unless letter

        letter = letter.to_sym
        @letter = letter
        parent[letter] = self if parent
      end
    end
  end
end
