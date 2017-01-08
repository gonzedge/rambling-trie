module Rambling
  module Trie
    # Serializer for Ruby yaml format (.yaml) files
    class YamlSerializer
      # Loads yamled object from file and deserializes it into a node.
      # @param [String] filepath the full path of the file to load the
      # object from yaml.
      # @return [Node] The deserialized Trie root node.
      def load filepath
        require 'yaml'
        YAML.load File.read filepath
      end

      def dump trie, filename
        require 'yaml'
        File.open "#{filename}.yml", 'w+' do |f|
          f.write YAML.dump trie.root
        end
      end
    end
  end
end
