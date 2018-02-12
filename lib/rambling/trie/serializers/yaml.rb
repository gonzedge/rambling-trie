module Rambling
  module Trie
    module Serializers
      # Serializer for Ruby yaml format (.yaml) files.
      class Yaml
        # Creates a new Yaml serializer.
        # @param [Serializer] serializer the serializer responsible to write to
        #   and read from disk.
        def initialize serializer = nil
          @serializer = serializer || Rambling::Trie::Serializers::File.new
        end

        # Loads serialized object from YAML file in filepath and deserializes
        # it into a {Nodes::Node Node}.
        # @param [String] filepath the full path of the file to load the
        #   serialized YAML object from.
        # @return [Nodes::Node] The deserialized {Node Node}.
        def load filepath
          require 'yaml'
          ::YAML.load serializer.load filepath
        end

        # Serializes a {Nodes::Node Node} and dumps it as a YAML object into filepath.
        # @param [Nodes::Node] node the node to serialize
        # @param [String] filepath the full path of the file to dump the YAML
        #   object into.
        # @return [Numeric] number of bytes written to disk.
        def dump node, filepath
          require 'yaml'
          serializer.dump ::YAML.dump(node), filepath
        end

        private

        attr_reader :serializer
      end
    end
  end
end
