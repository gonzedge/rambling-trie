module Rambling
  module Trie
    module Serializers
      # Serializer for Ruby yaml format (.yaml) files
      class Yaml
        # Loads yamled object from file and deserializes it into a node.
        # @param [String] filepath the full path of the file to load the
        # object from yaml.
        # @return [Node] The deserialized Trie root node.
        def load filepath
          require 'yaml'
          ::YAML.load File.read filepath
        end

        def dump trie, filepath
          require 'yaml'
          File.open filepath, 'w+' do |f|
            f.write ::YAML.dump trie.root
          end
        end
      end
    end
  end
end
