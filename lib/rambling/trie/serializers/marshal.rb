module Rambling
  module Trie
    module Serializers
      # Serializer for Ruby marshal format (.marshal) files.
      class Marshal
        # Creates a new Marshal serializer.
        # @param [Serializer] serializer the serializer responsible to write to
        #   and read from disk.
        def initialize serializer = nil
          @serializer = serializer || Rambling::Trie::Serializers::File.new
        end

        # Loads marshaled object from contents in filepath and deserializes it
        # into a {Nodes::Node Node}.
        # @param [String] filepath the full path of the file to load the
        #   marshaled object from.
        # @return [Nodes::Node] The deserialized {Nodes::Node Node}.
        def load filepath
          ::Marshal.load serializer.load filepath
        end

        # Serializes a {Nodes::Node Node} and dumps it as a marshaled object into
        # filepath.
        # @param [Nodes::Node] node the node to serialize
        # @param [String] filepath the full path of the file to dump the
        #   marshaled object into.
        # @return [Numeric] number of bytes written to disk.
        def dump node, filepath
          serializer.dump ::Marshal.dump(node), filepath
        end

        private

        attr_reader :serializer
      end
    end
  end
end
