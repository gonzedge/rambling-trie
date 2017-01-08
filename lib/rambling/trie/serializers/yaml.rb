module Rambling
  module Trie
    module Serializers
      # Serializer for Ruby yaml format (.yaml) files
      class Yaml
        def initialize serializer = nil
          @serializer = serializer || Rambling::Trie::Serializers::File.new
        end

        # Loads serialized object from YAML file and deserializes it into a
        # node.
        # @param [String] filepath the full path of the YAML file to load the
        # object from.
        # @return [Node] The deserialized Trie root node.
        def load filepath
          require 'yaml'
          ::YAML.load serializer.load filepath
        end

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
