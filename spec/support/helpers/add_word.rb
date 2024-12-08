# frozen_string_literal: true

module Support
  module Helpers
    module AddWord
      def add_words node, words, values = nil
        values ||= []
        words.zip(values).each { |word, value| add_word node, word, value }
      end

      def add_word node, word, value = nil
        case node
        when Rambling::Trie::Container
          node.add word, value
        else
          node.add word.chars.reverse.map(&:to_sym), value
        end
      end
    end
  end
end
