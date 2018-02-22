# frozen_string_literal: true

module Rambling
  module Trie
    module Readers
      # File reader for .txt files.
      class PlainText
        # Yields each word read from a .txt file.
        # @param [String] filepath the full path of the file to load the words
        #   from.
        # @yield [String] Each line read from the file.
        def each_word filepath
          File.foreach(filepath) { |line| yield line.chomp! }
        end
      end
    end
  end
end
