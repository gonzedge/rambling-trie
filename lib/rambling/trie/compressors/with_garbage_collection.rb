# frozen_string_literal: true

module Rambling
  module Trie
    module Compressors
      # Responsible for the compression process of a trie data structure, with garbage collection forced immediately
      # after compression to reduce memory consumption.
      class WithGarbageCollection < Compressor
        # Creates a new compressor with garbage collection capabilities.
        # @param [Compressor, nil] compressor ultimately responsible for compressing the trie.
        #   Defaults to {WithMergingStrategy}.
        def initialize compressor = nil
          super()
          @compressor = compressor || WithMergingStrategy.new
        end

        # Compresses a {Nodes::Node Node} from a trie data structure and triggers garbage collection.
        # @param [Nodes::Raw] node the node to compress.
        # @return [Nodes::Compressed] node the compressed version of the node.
        def compress node
          compressed_node = compressor.compress node

          ::GC.start

          compressed_node
        end

        private

        attr_reader :compressor
      end
    end
  end
end
