# frozen_string_literal: true

module Rambling
  module Trie
    module Readers
      # File reader for +.txt+ files.
      class PlainText < Reader
        # Yields each word read from a +.txt+ file.
        # @param [String] filepath the full path of the file to load the words
        #   from.
        # @yield [String] Each line read from the file.
        # @return [self]
        def each_word filepath
          return enum_for :each_word unless block_given?

          ::File.foreach(filepath) { |line| yield line.chomp! }

          self
        end
      end
    end
  end
end
