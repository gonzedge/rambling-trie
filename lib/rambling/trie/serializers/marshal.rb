# frozen_string_literal: true

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
        # @see https://ruby-doc.org/core-2.5.0/Marshal.html#method-c-load
        #   Marshal.load
        # @note Use of
        #   {https://ruby-doc.org/core-2.5.0/Marshal.html#method-c-load
        #   Marshal.load} is generally discouraged. Only use this with trusted
        #   input.
        def load filepath
          ::Marshal.load serializer.load filepath
        end

        # Serializes a {Nodes::Node Node} and dumps it as a marshaled object
        # into filepath.
        # @param [Nodes::Node] node the node to serialize
        # @param [String] filepath the full path of the file to dump the
        #   marshaled object into.
        # @return [Numeric] number of bytes written to disk.
        # @see https://ruby-doc.org/core-2.5.0/Marshal.html#method-c-dump
        #   Marshal.dump
        def dump node, filepath
          serializer.dump ::Marshal.dump(node), filepath
        end

        private

        attr_reader :serializer
      end
    end
  end
end
