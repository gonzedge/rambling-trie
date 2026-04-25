# frozen_string_literal: true

module Rambling
  module Trie
    module Serializers
      # Base class for all serializers.
      class Serializer
        include NotImplemented

        # Loads contents from a specified filepath.
        # @abstract Subclass and override {#load} to parse the desired format.
        # @param [String] filepath the filepath to load contents from.
        # @return [TContents] parsed contents from given file.
        # @raise [NotImplementedError] when not overridden by a subclass
        def load _filepath
          not_implemented
        end

        # Dumps contents into a specified filepath.
        # @abstract Subclass and override {#dump} to output the desired format.
        # @param [TContents] contents the contents to dump into given file.
        # @param [String] filepath the filepath to dump the contents to.
        # @return [Numeric] number of bytes written to disk.
        # @raise [NotImplementedError] when not overridden by a subclass
        def dump _contents, _filepath
          not_implemented
        end
      end
    end
  end
end
