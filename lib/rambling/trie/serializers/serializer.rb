# frozen_string_literal: true

module Rambling
  module Trie
    module Serializers
      # Base class for all serializers.
      class Serializer
        # Loads contents from a specified filepath.
        # @abstract Subclass and override {#load} to parse the desired format.
        # @param [String] filepath the filepath to load contents from.
        # @return [TContents] parsed contents from given file.
        # :reek:UnusedParameters
        def load filepath
          raise NotImplementedError
        end

        # Dumps contents into a specified filepath.
        # @abstract Subclass and override {#dump} to output the desired format.
        # @param [TContents] contents the contents to dump into given file.
        # @param [String] filepath the filepath to dump the contents to.
        # @return [Numeric] number of bytes written to disk.
        # :reek:UnusedParameters
        def dump contents, filepath
          raise NotImplementedError
        end
      end
    end
  end
end
