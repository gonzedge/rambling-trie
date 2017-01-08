module Rambling
  module Trie
    module Serializers
      # Serializer for Ruby marshal format (.marshal) files
      class Marshal
        def initialize serializer = nil
          @serializer = serializer || Rambling::Trie::Serializers::File.new
        end

        # Loads marshaled object from file and deserializes it into a node.
        # @param [String] filepath the full path of the file to load the
        # marshaled object.
        # @return [Node] The deserialized Trie root node.
        def load filepath
          ::Marshal.load serializer.load filepath
        end

        def dump trie, filepath
          serializer.dump ::Marshal.dump(trie.root), filepath
        end

        private

        attr_reader :serializer
      end
    end
  end
end
