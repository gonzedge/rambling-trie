# frozen_string_literal: true

module Rambling
  module Trie
    # Provides enumerable behavior to the trie data structure.
    module Enumerable
      include ::Enumerable

      # Empty enumerator constant for early each exits.
      EMPTY_ENUMERATOR = [] # : Array[String]
                         .to_enum :each

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
    end
  end
end
