module Rambling
  module Trie
    module Readers
      # File reader for .txt files
      class PlainText
        # Yields each word read from a .txt file
        # @param [String] filepath the full path of the file to load the words
        # from.
        # @yield [String] Each line read from the file.
        def each_word filepath
          each_line(filepath) { |line| yield line.chomp! }
        end

        private

        def each_line filepath
          open(filepath) { |file| file.each_line { |line| yield line } }
        end

        def open filepath
          File.open(filepath) { |file| yield file }
        end
      end
    end
  end
end
