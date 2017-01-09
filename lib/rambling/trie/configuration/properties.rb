module Rambling
  module Trie
    module Configuration
      class Properties
        attr_reader :readers, :serializers
        attr_accessor :compressor, :root_builder

        def initialize
          reset
        end

        def reset
          reset_readers
          reset_serializers

          self.compressor = Rambling::Trie::Compressor.new
          self.root_builder = lambda { Rambling::Trie::RawNode.new }
        end

        private

        attr_writer :readers, :serializers

        def reset_readers
          plain_text_reader = Rambling::Trie::Readers::PlainText.new

          self.readers = Rambling::Trie::Configuration::ProviderCollection.new 'reader', txt: plain_text_reader
        end

        def reset_serializers
          marshal_serializer = Rambling::Trie::Serializers::Marshal.new
          yaml_serializer = Rambling::Trie::Serializers::Yaml.new

          self.serializers = Rambling::Trie::Configuration::ProviderCollection.new 'serializer',
            marshal: marshal_serializer,
            yml: yaml_serializer,
            yaml: yaml_serializer
        end
      end
    end
  end
end
