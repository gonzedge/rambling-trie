# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a missing node in the trie data structure. Returned when a node is not found.
      class Missing < Rambling::Trie::Nodes::Node
        def partial_word? _chars
          false
        end

        private

        def word_chars? _chars
          false
        end

        def closest_node _chars
          self
        end

        def children_match_prefix _chars
          return enum_for :children_match_prefix, _chars unless block_given?
        end
      end
    end
  end
end
