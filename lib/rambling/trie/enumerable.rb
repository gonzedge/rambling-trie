module Rambling
  module Trie
    # Provides enumerable behavior to the Trie data structure.
    module Enumerable
      include ::Enumerable

      alias_method :size, :count

      # Calls block once for each of the words contained in the trie. If no block given, an Enumerator is returned.
      def each &block
        enumerator = Enumerator.new do |words|
          words << as_word if terminal?
          children.each { |child| child.each { |word| words << word } }
        end

        block.nil? ? enumerator : enumerator.each(&block)
      end
    end
  end
end
