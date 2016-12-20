module Rambling
  module Trie
    # A representation of a node in an uncompressed Trie data structure.
    class RawNode < Rambling::Trie::Node
      # Creates a new Node.
      # @param [Node, nil] parent the parent of this node.
      def initialize word = nil, parent = nil
        super parent

        unless word.nil? || word.empty?
          self.letter = word.slice! 0
          self.terminal = word.empty?
          self.add word
        end
      end

      # Adds a branch to the current trie node based on the word
      # @param [String] word the word to add the branch from.
      # @return [Rambling::Trie::RawNode] the just added branch's root node.
      # @note This method clears the contents of the word variable.
      def add word
        if word.empty?
          terminal!
        else
          add_to_children_tree word
        end
      end

      def partial_word? chars = []
        chars.empty? || fulfills_condition?(:partial_word?, chars)
      end

      def word? chars = []
        if chars.empty?
          terminal?
        else
          fulfills_condition? :word?, chars
        end
      end

      def scan chars
        closest_node(chars).to_a
      end

      def compressed?
        false
      end

      protected

      def closest_node chars
        if chars.empty?
          self
        else
          first_letter_sym = chars.slice!(0).to_sym
          if children_tree.has_key? first_letter_sym
            children_tree[first_letter_sym].closest_node chars
          else
            Rambling::Trie::MissingNode.new
          end
        end
      end

      private

      def add_to_children_tree word
        first_letter = word.slice(0).to_sym

        if children_tree.has_key? first_letter
          word.slice! 0
          child = children_tree[first_letter]
          child.add word
          child
        else
          children_tree[first_letter] = Rambling::Trie::RawNode.new word, self
        end
      end

      def fulfills_condition? method, chars
        first_letter_sym = chars.slice!(0).to_sym
        children_tree.has_key?(first_letter_sym) && children_tree[first_letter_sym].send(method, chars)
      end
    end
  end
end
