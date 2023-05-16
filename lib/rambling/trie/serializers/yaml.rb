# frozen_string_literal: true

module Rambling
  module Trie
    module Serializers
      # Serializer for Ruby yaml format (+.yaml+, or +.yml+) files.
      class Yaml < Serializer
        # Creates a new Yaml serializer.
        # @param [Serializer] serializer the serializer responsible to write to and read from disk.
        # :reek:ControlParameter
        def initialize serializer = nil
          super()
          @serializer = serializer || Rambling::Trie::Serializers::File.new
        end

        # Loads serialized object from YAML file in filepath and deserializes it into a {Nodes::Node Node}.
        # @param [String] filepath the full path of the file to load the serialized YAML object from.
        # @return [Nodes::Node] The deserialized {Nodes::Node Node}.
        # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/psych/rdoc/Psych.html#method-c-safe_load Psych.safe_load
        def load filepath
          require 'yaml'
          ::YAML.safe_load(
            serializer.load(filepath),
            permitted_classes: [
              Symbol,
              Rambling::Trie::Nodes::Raw,
              Rambling::Trie::Nodes::Compressed,
            ],
            aliases: true,
          )
        end

        # Serializes a {Nodes::Node Node} and dumps it as a YAML object into filepath.
        # @param [Nodes::Node] node the node to serialize
        # @param [String] filepath the full path of the file to dump the YAML object into.
        # @return [Numeric] number of bytes written to disk.
        # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/psych/rdoc/Psych.html#method-c-dump Psych.dump
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
