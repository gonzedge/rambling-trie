module Support
  module Helpers
    module AddWord
      def add_words node, words
        words.each { |word| add_word node, word }
      end

      def add_word node, word
        case node
        when Rambling::Trie::Container
          node.add word
        else
          node.add word.chars.reverse.map(&:to_sym)
        end
      end
    end
  end
end
