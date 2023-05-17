# frozen_string_literal: true

module Rambling
  module Trie
    module Compressors
      # Base class for all compressors.
      class Compressor
        # Compresses a {Nodes::Node Node} from a trie data structure.
        # @param [Nodes::Raw] node the node to compress.
        # @return [Nodes::Compressed] node the compressed version of the node.
        # :reek:UnusedParameters
        def each_word node
          raise NotImplementedError
        end
      end
    end
  end
end
