module Rambling
  module Trie
    # A representation of a node in the Trie data structure.
    class Node
      include ChildrenHashDeferer
      include Compressor
      include Branches
      include Enumerable

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
      # @param [String, nil] word the word from which to create this Node and his branch (defaults to nil).
      # @param [Node, nil] parent the parent of this node (defaults to nil).
      def initialize(word = nil, parent = nil)
        @letter, @parent, @terminal, @children = [nil, parent, false, {}]

        unless word.nil? or word.empty?
          letter = word.slice! 0
          @letter = letter.to_sym unless letter.nil?
          @terminal = word.empty?
          self << word
        end
      end

      # Flag for terminal nodes.
      # @return [Boolean] `true` for terminal nodes, `false` otherwise.
      def terminal?
        @terminal
      end

      # String representation of the current node, if it is a terminal node.
      # @return [String] the string representation of the current node.
      # @raise [InvalidOperation] if node is not terminal or is root.
      def as_word
        raise InvalidOperation, 'Cannot represent branch as a word' unless @letter.nil? or terminal?
        get_letter_string
      end

      protected
      def get_letter_string
        (@parent.nil? ? '' : @parent.get_letter_string) << @letter.to_s
      end
    end
  end
end
