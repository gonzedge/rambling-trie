require 'spec_helper'

describe Rambling::Trie::Configuration::Properties do
  let(:properties) { Rambling::Trie::Configuration::Properties.new }

  describe '.new' do
    it 'configures the serializers' do
      serializers = properties.serializers
      expect(serializers.formats).to match_array %i(marshal yaml yml zip)

      expect(serializers[:marshal]).to be_instance_of Rambling::Trie::Serializers::Marshal
      expect(serializers[:yaml]).to be_instance_of Rambling::Trie::Serializers::Yaml
      expect(serializers[:yml]).to be_instance_of Rambling::Trie::Serializers::Yaml
      expect(serializers[:zip]).to be_instance_of Rambling::Trie::Serializers::Zip
    end

    it 'configures the readers' do
      readers = properties.readers
      expect(readers.formats).to match_array %i(txt)

      expect(readers[:txt]).to be_instance_of Rambling::Trie::Readers::PlainText
    end

    it 'configures the compressor' do
      expect(properties.compressor).to be_instance_of Rambling::Trie::Compressor
    end

    it 'configures the root_builder' do
      expect(properties.root_builder.call).to be_instance_of Rambling::Trie::Nodes::Raw
    end
  end

  describe '#reset' do
    before do
      properties.serializers.add :test, 'test'
      properties.readers.add :test, 'test'
    end

    it 'resets the serializers and readers to initial values' do
      expect(properties.serializers.formats).to include :test
      expect(properties.readers.formats).to include :test

      properties.reset

      expect(properties.serializers.formats).not_to include :test
      expect(properties.readers.formats).not_to include :test
    end
  end
end
