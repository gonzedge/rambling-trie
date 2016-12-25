module Rambling
  module Trie
    # Provides enumerable behavior to the Trie data structure.
    module Enumerable
      include ::Enumerable

      alias_method :size, :count

      # Iterates over the words contained in the trie.
      # @yield [String] the words contained in this trie node.
      def each
        return enum_for :each unless block_given?

        yield as_word if terminal?

        children.each do |child|
          child.each do |word|
            yield word
          end
        end
      end
    end
  end
end
