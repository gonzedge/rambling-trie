# frozen_string_literal: true

module Rambling
  module Trie
    # Provides enumerable behavior to the trie data structure.
    # :reek:TooManyStatements { max_statements: 10 }
    module Enumerable
      include ::Enumerable

      # Returns number of words contained in the trie
      # @see https://ruby-doc.org/core-2.7.0/Enumerable.html#method-i-count Enumerable#count
      alias_method :size, :count

      # Iterates over the words contained in the trie.
      # @yield [String] the words contained in this trie node.
      # @return [self]
      # :reek:NestedIterators
      def each
        return enum_for :each unless block_given?

        yield as_word if terminal?

        children_tree.each_value do |child|
          child.each do |word|
            yield word
          end
        end

        self
      end
    end
  end
end
