module Rambling
  module Trie
    module Configuration
      # Provides configurable properties for Rambling::Trie.
      class Properties
        # The configured {Readers Readers}.
        # @return [ProviderCollection] the mapping of configured {Readers
        #   Readers}.
        attr_reader :readers

        # The configured {Serializers Serializers}.
        # @return [ProviderCollection] the mapping of configured {Serializers
        #   Serializers}.
        attr_reader :serializers

        # The configured {Compressor Compressor}.
        # @return [Compressor] the configured compressor.
        attr_accessor :compressor

        # The configured root_builder, which should return a {Nodes::Node Node} when
        # called.
        # @return [Proc<Nodes::Node>] the configured root_builder.
        attr_accessor :root_builder

        attr_accessor :tmp_path

        # Returns a new properties instance.
        def initialize
          reset
        end

        # Resets back to default properties.
        def reset
          reset_readers
          reset_serializers

          self.compressor = Rambling::Trie::Compressor.new
          self.root_builder = lambda { Rambling::Trie::Nodes::Raw.new }
          self.tmp_path = '/tmp'
        end

        private

        attr_writer :readers, :serializers

        def reset_readers
          plain_text_reader = Rambling::Trie::Readers::PlainText.new

          self.readers = Rambling::Trie::Configuration::ProviderCollection.new :reader, txt: plain_text_reader
        end

        def reset_serializers
          marshal_serializer = Rambling::Trie::Serializers::Marshal.new
          yaml_serializer = Rambling::Trie::Serializers::Yaml.new
          zip_serializer = Rambling::Trie::Serializers::Zip.new self

          self.serializers = Rambling::Trie::Configuration::ProviderCollection.new :serializer,
            marshal: marshal_serializer,
            yml: yaml_serializer,
            yaml: yaml_serializer,
            zip: zip_serializer
        end
      end
    end
  end
end
