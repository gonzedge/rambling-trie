module Rambling
  module Trie
    class Container
      extend ::Forwardable

      include ::Enumerable

      delegate [
        :each,
        :add,
        :word?,
        :include?,
        :partial_word?,
        :scan,
        :match?,
        :compress!,
        :compressed?
      ] => :root

      # Creates a new Trie.
      # @yield [Container] the trie just created.
      def initialize
        @root = Rambling::Trie::Root.new

        yield self if block_given?
      end

      # Adds a branch to the trie based on the word, without changing the passed word.
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see Branches#add
      # @note Avoids clearing the contents of the word variable.
      def add word
        root.add word.clone
      end

      alias_method :include?, :word?
      alias_method :match?, :partial_word?
      alias_method :words, :scan
      alias_method :<<, :add

      private

      attr_reader :root
    end
  end
end
