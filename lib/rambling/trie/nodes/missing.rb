# frozen_string_literal: true

module Rambling
  module Trie
    module Nodes
      # A representation of a missing node in the trie data structure. Returned when a node is not found.
      class Missing < Rambling::Trie::Nodes::Node
        def partial_word? _
          false
        end

        private

        def word_chars? _
          false
        end

        def closest_node _
          self
        end

        def children_match_prefix chars
          enum_for :children_match_prefix, chars unless block_given?
        end
      end
    end
  end
end
