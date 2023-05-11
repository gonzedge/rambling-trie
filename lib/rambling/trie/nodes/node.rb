# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a node in the trie data structure.
      class Node
        include Rambling::Trie::Compressible
        include Rambling::Trie::Enumerable
        include Rambling::Trie::Comparable
        include Rambling::Trie::Stringifyable
        include Rambling::Trie::Inspectable

        # @overload letter
        #   Letter(s) corresponding to the current node.
        # @overload letter=(letter)
        #   Sets the letter(s) corresponding to the current node. Ensures the
        #   {Node#letter #letter} in the {Node#parent #parent}'s
        #   {Node#children_tree #children_tree} is updated.
        #   @param [String, Symbol, nil] letter the letter value.
        # @return [Symbol, nil] the corresponding letter(s).
        attr_reader :letter

        # Child nodes tree.
        # @return [Hash<Symbol, Node>] the children tree hash, consisting of
        #   +:letter => node+.
        attr_accessor :children_tree

        # Parent node.
        # @return [Node, nil] the parent of the current node.
        attr_accessor :parent

        # Creates a new node.
        # @param [Symbol, nil] letter the Node's letter value.
        # @param [Node, nil] parent the parent of the current node.
        def initialize letter = nil, parent = nil, children_tree = {}
          @letter = letter
          @parent = parent
          @children_tree = children_tree
        end

        # Child nodes.
        # @return [Array<Node>] the array of child nodes contained
        #   in the current node.
        def children
          children_tree.values
        end

        # First child node.
        # @return [Node, nil] the first child contained in the current node.
        def first_child
          return if children_tree.empty?

          # rubocop:disable Lint/UnreachableLoop
          children_tree.each_value { |child| return child }
          # rubocop:enable Lint/UnreachableLoop
        end

        # Indicates if the current node is the root node.
        # @return [Boolean] +true+ if the node does not have a parent, +false+
        #   otherwise.
        def root?
          !parent
        end

        # Indicates if a {Node Node} is terminal or not.
        # @return [Boolean] +true+ for terminal nodes, +false+ otherwise.
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
          @letter = letter.to_sym if letter
        end

        # Checks if a path for a set of characters exists in the trie.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Boolean] +true+ if the characters are found, +false+
        #   otherwise.
        def partial_word? chars
          return true if chars.empty?

          partial_word_chars? chars
        end

        # Checks if a path for set of characters represents a word in the trie.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Boolean] +true+ if the characters are found and form a word,
        #   +false+ otherwise.
        def word? chars = []
          return terminal? if chars.empty?

          word_chars? chars
        end

        # Returns the node that starts with the specified characters.
        # @param [Array<String>] chars the characters to look for in the trie.
        # @return [Node] the node that matches the specified characters.
        #   {Missing Missing} when not found.
        def scan chars
          return self if chars.empty?

          closest_node chars
        end

        # Returns all words that match a prefix of any length within chars.
        # @param [String] chars the chars to base the prefix on.
        # @return [Enumerator<String>] all the words that match a prefix given
        #   by chars.
        # @yield [String] each word found.
        def match_prefix chars
          return enum_for :match_prefix, chars unless block_given?

          yield as_word if terminal?

          children_match_prefix chars do |word|
            yield word
          end
        end

        # Get {Node Node} corresponding to a given letter.
        # @param [Symbol] letter the letter to search for in the node.
        # @return [Node] the node corresponding to that letter.
        # @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-5B-5D
        #   Hash#[]
        def [] letter
          children_tree[letter]
        end

        # Set the {Node Node} that corresponds to a given letter.
        # @param [Symbol] letter the letter to insert or update in the node's
        # @param [Node] node the {Node Node} to assign to that letter.
        # @return [Node] the node corresponding to the inserted or
        #   updated letter.
        # @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-5B-5D
        #   Hash#[]
        def []= letter, node
          children_tree[letter] = node
        end

        # Check if a {Node Node}'s children tree contains a given
        #   letter.
        # @param [Symbol] letter the letter to search for in the node.
        # @return [Boolean] +true+ if the letter is present, +false+ otherwise.
        # @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-has_key-3F
        #   Hash#key?
        def key? letter
          children_tree.key? letter
        end

        # Delete a given letter and its corresponding {Node Node} from
        # this {Node Node}'s children tree.
        # @param [Symbol] letter the letter to delete from the node's children
        #   tree.
        # @return [Node] the node corresponding to the deleted letter.
        # @see https://ruby-doc.org/core-2.7.0/Hash.html#method-i-delete
        #   Hash#delete
        def delete letter
          children_tree.delete letter
        end

        alias_method :has_key?, :key?

        protected

        def missing
          Rambling::Trie::Nodes::Missing.new
        end

        private

        attr_accessor :terminal
      end
    end
  end
end
