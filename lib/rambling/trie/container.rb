module Rambling
  module Trie
    class Container
      extend Forwardable

      include Enumerable

      delegate [
        :each,
        :add,
        :<<,
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

      alias_method :include?, :word?
      alias_method :match?, :partial_word?
      alias_method :words, :scan

      private

      attr_reader :root
    end
  end
end
