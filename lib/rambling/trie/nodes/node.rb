module Rambling
  module Trie
    module Nodes
      # A representation of a node in the trie data structure.
      class Node
        extend ::Forwardable
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
        #   {Nodes::Node#letter #letter} in the {Node#parent #parent}'s
        #   {Nodes::Node#children_tree #children_tree} is updated.
        #   @param [String, Symbol, nil] letter the letter value.
        # @return [Symbol, nil] the corresponding letter(s).
        attr_reader :letter

        # Children nodes tree.
        # @return [Hash] the children_tree hash, consisting of `:letter => node`.
        attr_accessor :children_tree

        # Parent node.
        # @return [Nodes::Node, nil] the parent of the current node.
        attr_accessor :parent

        # Creates a new node.
        # @param [Symbol, nil] letter the Node's letter value
        # @param [Nodes::Node, nil] parent the parent of the current node.
        def initialize letter = nil, parent = nil
          self.letter = letter
          self.parent = parent
          self.children_tree = {}
        end

        # Children nodes.
        # @return [Array<Nodes::Node>] the array of children nodes contained in the
        #   current node.
        def children
          children_tree.values
        end

        # First child node.
        # @return [Nodes::Node, nil] the first child contained in the current node.
        def first_child
          return if children_tree.empty?

          children_tree.each_value do |child|
            return child
          end
        end

        # Indicates if the current node is the root node.
        # @return [Boolean] `true` if the node does not have a parent, `false`
        #   otherwise.
        def root?
          !parent
        end

        # Indicates if a {Nodes::Node Node} is terminal or not.
        # @return [Boolean] `true` for terminal nodes, `false` otherwise.
        def terminal?
          !!terminal
        end

        # Mark {Nodes::Node Node} as terminal.
        # @return [Nodes::Node] the modified node.
        def terminal!
          self.terminal = true
          self
        end

        def letter= letter
          @letter = letter.to_sym if letter
        end

        # Returns the node that starts with the specified characters.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Nodes::Node] the node that matches the specified characters.
        #   {Nodes::Missing Missing} when not found.
        def scan chars
          return self if chars.empty?

          closest_node chars
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
end
