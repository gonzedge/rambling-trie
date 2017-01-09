require 'spec_helper'

describe Rambling::Trie::Configuration::Properties do
  let(:properties) { Rambling::Trie::Configuration::Properties.new }

  describe '.new' do
    it 'configures the serializers' do
      serializers = properties.serializers
      expect(serializers.keys).to match_array %i(marshal yaml yml)

      expect(serializers[:marshal]).to be_instance_of Rambling::Trie::Serializers::Marshal
      expect(serializers[:yaml]).to be_instance_of Rambling::Trie::Serializers::Yaml
      expect(serializers[:yml]).to be_instance_of Rambling::Trie::Serializers::Yaml
    end

    it 'configures the readers' do
      readers = properties.readers
      expect(readers.keys).to match_array %i(txt)

      expect(readers[:txt]).to be_instance_of Rambling::Trie::Readers::PlainText
    end
  end

  describe '#reset' do
    before do
      properties.serializers.add :test, 'test'
      properties.readers.add :test, 'test'

      properties.reset
    end

    it 'resets the serializers and readers to initial values' do
      expect(properties.serializers.keys).to match_array %i(marshal yaml yml)
      expect(properties.readers.keys).to match_array %i(txt)
    end
  end
end
