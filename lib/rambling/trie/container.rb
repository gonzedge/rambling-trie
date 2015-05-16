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
        :match?,
        :compress!,
        :compressed?
      ] => :root

      def initialize
        @root = Rambling::Trie::Root.new

        yield self if block_given?
      end

      private

      attr_reader :root
    end
  end
end
