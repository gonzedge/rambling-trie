module Rambling
  module Trie
    module Serializers
      # Serializer for Ruby marshal format (.marshal) files
      class Marshal
        # Loads marshaled object from file and deserializes it into a node.
        # @param [String] filepath the full path of the file to load the
        # marshaled object.
        # @return [Node] The deserialized Trie root node.
        def load filepath
          ::Marshal.load File.read filepath
        end

        def dump trie, filepath
          File.open filepath, 'w+' do |f|
            f.write ::Marshal.dump trie.root
          end
        end
      end
    end
  end
end
