module Rambling
  module Trie
    # A representation of a node in the Trie data structure.
    class Node
      include ChildrenHashDeferer
      include Compressor
      include Branches

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
      # @param [String] word the word from which to create this Node and his branch.
      # @param [Node] parent the parent of this node.
      def initialize(word, parent = nil)
        @letter = nil
        @parent = parent
        @is_terminal = false
        @children = {}

        unless word.nil? or word.empty?
          letter = word.slice!(0)
          @letter = letter.to_sym unless letter.nil?
          @is_terminal = word.empty?
          add_branch_from(word)
        end
      end

      # Flag for terminal nodes.
      # @return [Boolean] `true` for terminal nodes, `false` otherwise.
      def terminal?
        @is_terminal
      end

      # String representation of the current node, if it is a terminal node.
      # @return [String] the string representation of the current node.
      # @raise [InvalidOperation] if node is not terminal or is root.
      def as_word
        raise InvalidOperation.new() unless @letter.nil? or terminal?
        get_letter_string
      end

      protected
      def get_letter_string
        (@parent.nil? ? '' : @parent.get_letter_string) + @letter.to_s
      end
    end
  end
end
