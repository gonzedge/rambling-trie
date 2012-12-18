module Rambling
  module Trie
    # Provides pretty printing behavior for the Trie data structure.
    module Inspector
      # @return [String] a string representation of the current node.
      def inspect
        "#<#{self.class.name} letter: #{letter.inspect or 'nil'}, children: #{children.keys}>"
      end
    end
  end
end
