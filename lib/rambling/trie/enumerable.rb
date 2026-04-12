# frozen_string_literal: true

module Rambling
  module Trie
    # Provides enumerable behavior to the trie data structure.
    module Enumerable
      include ::Enumerable

      # Returns number of words contained in the trie
      # @see https://ruby-doc.org/3.3.0/Enumerable.html#method-i-count Enumerable#count
      alias_method :size, :count

      # Iterates over the words contained in the trie.
      # @yield [String] the words contained in this trie node.
      # @return [self]
      def each
        return enum_for :each unless block_given?

        yield as_word if terminal?

        children_tree.each_value { |child| child.each { |word| yield word } }

        self
      end

      # Returns a new empty enumerator for early-exit returns.
      # A method rather than a constant to prevent shared mutable state.
      def empty_enum
        # @type var empty_array: Array[String]
        empty_array = []
        empty_array.each
      end
    end
  end
end
