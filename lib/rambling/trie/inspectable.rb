# frozen_string_literal: true

module Rambling
  module Trie
    # Provides pretty printing behavior for the trie data structure.
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
          value_inspect,
          terminal_inspect,
          children_inspect,
        ].compact.join ', '
      end

      def letter_inspect
        "letter: #{letter.inspect}"
      end

      def value_inspect
        value && "value: #{value.inspect}"
      end

      def terminal_inspect
        "terminal: #{terminal.inspect}"
      end

      def children_inspect
        "children: #{children_tree.keys.inspect}"
      end
    end
  end
end
