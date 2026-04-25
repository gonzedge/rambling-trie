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
        def load _filepath
          raise NotImplementedError, "#{self.class}##{__method__} is not implemented"
        end

        # Dumps contents into a specified filepath.
        # @abstract Subclass and override {#dump} to output the desired format.
        # @param [TContents] contents the contents to dump into given file.
        # @param [String] filepath the filepath to dump the contents to.
        # @return [Numeric] number of bytes written to disk.
        def dump _contents, _filepath
          raise NotImplementedError, "#{self.class}##{__method__} is not implemented"
        end
      end
    end
  end
end
