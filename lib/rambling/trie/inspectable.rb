module Rambling
  module Trie
    # Provides pretty printing behavior for the Trie data structure.
    module Inspectable
      # @return [String] a string representation of the current node.
      def inspect
        "#<#{class_name} #{attributes}>"
      end

      private

      def class_name
        self.class.name
      end

      def attributes
        [
          letter_inspect,
          children_inspect,
        ].join ', '
      end

      def letter_inspect
        "letter: #{letter.inspect}"
      end

      def children_inspect
        "children: #{children_tree.keys}"
      end
    end
  end
end
