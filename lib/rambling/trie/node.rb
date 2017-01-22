module Rambling
  module Trie
    # A representation of a node in the trie data structure.
    class Node
      extend Rambling::Trie::Forwardable
      include Rambling::Trie::Compressable
      include Rambling::Trie::Enumerable
      include Rambling::Trie::Comparable
      include Rambling::Trie::Stringifyable
      include Rambling::Trie::Inspectable

      delegate [
        :[],
        :[]=,
        :delete,
        :has_key?
      ] => :children_tree

      # @overload letter
      #   Letter(s) corresponding to the current node.
      # @overload letter=(letter)
      #   Sets the letter(s) corresponding to the current node. Ensures the
      #   {Node#letter #letter} in the {Node#parent #parent}'s
      #   {Node#children_tree #children_tree} is updated.
      #   @param [String, Symbol, nil] letter the new letter value.
      # @return [Symbol, nil] the corresponding letter(s).
      attr_reader :letter

      # Children nodes tree.
      # @return [Hash] the children_tree hash, consisting of `:letter => node`.
      attr_accessor :children_tree

      # Parent node.
      # @return [Node, nil] the parent of the current node.
      attr_accessor :parent

      # Creates a new node.
      # @param [Node, nil] parent the parent of the current node.
      def initialize parent = nil
        self.parent = parent
        self.children_tree = {}
      end

      # Children nodes.
      # @return [Array<Node>] the array of children nodes contained in the
      #   current node.
      def children
        children_tree.values
      end

      # Indicates if the current node is the root node.
      # @return [Boolean] `true` if the node does not have a parent, `false`
      #   otherwise.
      def root?
        !parent
      end

      # Indicates if a {Node Node} is terminal or not.
      # @return [Boolean] `true` for terminal nodes, `false` otherwise.
      def terminal?
        !!terminal
      end

      # Mark {Node Node} as terminal.
      # @return [Node] the modified node.
      def terminal!
        self.terminal = true
        self
      end

      def letter= letter
        if letter
          @letter = letter.to_sym
          parent[letter] = self if parent
        end
      end

      # Returns all words that match a prefix of any length within chars.
      # @param [String] chars the chars to base the prefix on.
      # @return [Enumerator<String>] all the words that match a prefix given by
      #   chars.
      # @yield [String] each word found.
      def match_prefix chars
        return enum_for :match_prefix, chars unless block_given?

        yield as_word if terminal?
        children_match_prefix chars do |word|
          yield word
        end
      end

      private

      attr_accessor :terminal
    end
  end
end
