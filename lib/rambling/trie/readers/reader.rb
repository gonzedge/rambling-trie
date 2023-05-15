# frozen_string_literal: true

module Rambling
  module Trie
    module Readers
      # Base class for all readers.
      class Reader
        # Yields each word read from given file.
        # @abstract Subclass and override {#each_word} to fit to a particular
        #   file format.
        # @param [String] filepath the full path of the file to load the words
        #   from.
        # @yield [String] Each line read from the file.
        # @return [self]
        # :reek:UnusedParameters
        def each_word filepath
          raise NotImplementedError
        end
      end
    end
  end
end
