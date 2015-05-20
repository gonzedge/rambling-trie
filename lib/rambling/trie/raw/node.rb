module Rambling
  module Trie
    module Raw
      # A representation of a node in an uncompressed Trie data structure.
      class Node < Rambling::Trie::Node
        # Adds a branch to the current trie node based on the word
        # @param [String] word the word to add the branch from.
        # @return [Rambling::Trie::Raw::Node] the just added branch's root node.
        # @note This method clears the contents of the word variable.
        def add word
          if word.empty?
            terminal!
          else
            add_to_children_tree word
          end
        end

        def partial_word? chars
          chars.empty? || fulfills_condition?(:partial_word?, chars)
        end

        def word? chars
          if chars.empty?
            terminal?
          else
            fulfills_condition? :word?, chars
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
            children_tree[first_letter] = Rambling::Trie::Raw::Node.new word, self
          end
        end

        def fulfills_condition? method, chars
          first_letter_sym = chars.slice!(0).to_sym
          children_tree.has_key?(first_letter_sym) && children_tree[first_letter_sym].send(method, chars)
        end
      end
    end
  end
end
