module Rambling
  module Trie
    # Provides pretty printing behavior for the Trie data structure.
    module Inspector
      def inspect
        "#<#{self.class.name} letter: #{letter.inspect or 'nil'}, children: #{children.keys}>"
      end
    end
  end
end
