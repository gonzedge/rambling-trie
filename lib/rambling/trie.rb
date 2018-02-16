%w{
  comparable compressible compressor configuration container enumerable
  inspectable invalid_operation readers serializers stringifyable nodes
  version
}.each do |file|
  require File.join('rambling', 'trie', file)
end

# General namespace for all Rambling gems.
module Rambling
  # Entry point for rambling-trie API.
  module Trie
    class << self
      # Creates a new Rambling::Trie. Entry point for the Rambling::Trie API.
      # @param [String, nil] filepath the file to load the words from.
      # @param [Reader, nil] reader the file parser to get each word. See
      #   {Rambling::Trie::Readers Readers}.
      # @return [Container] the trie just created.
      # @yield [Container] the trie just created.
      def create filepath = nil, reader = nil
        Rambling::Trie::Container.new root_builder.call, compressor do |container|
          if filepath
            reader ||= readers.resolve filepath
            reader.each_word filepath do |word|
              container << word
            end
          end

          yield container if block_given?
        end
      end

      # Loads an existing trie from disk into memory.
      # @param [String] filepath the file to load the words from.
      # @param [Serializer, nil] serializer the object responsible of loading the trie
      #   from disk. See {Rambling::Trie::Serializers Serializers}.
      # @return [Container] the trie just loaded.
      # @yield [Container] the trie just loaded.
      def load filepath, serializer = nil
        serializer ||= serializers.resolve filepath
        root = serializer.load filepath
        Rambling::Trie::Container.new root, compressor do |container|
          yield container if block_given?
        end
      end

      # Dumps an existing trie from memory into disk.
      # @param [Container] trie the trie to dump into disk.
      # @param [String] filepath the file to dump to serialized trie into.
      # @param [Serializer, nil] serializer the object responsible of
      #   serializing and dumping the trie into disk. See
      #   {Rambling::Trie::Serializers Serializers}.
      def dump trie, filepath, serializer = nil
        serializer ||= serializers.resolve filepath
        serializer.dump trie.root, filepath
      end

      # Provides configuration properties for the Rambling::Trie gem.
      # @return [Properties] the configured properties of the gem.
      # @yield [Properties] the configured properties of the gem.
      def config
        yield properties if block_given?
        properties
      end

      private

      def properties
        @properties ||= Rambling::Trie::Configuration::Properties.new
      end

      def readers
        properties.readers
      end

      def serializers
        properties.serializers
      end

      def compressor
        properties.compressor
      end

      def root_builder
        properties.root_builder
      end
    end
  end
end
