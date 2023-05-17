# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Configuration::Properties do
  let(:properties) { described_class.new }

  describe '.new' do
    it 'configures the serializer formats' do
      serializers = properties.serializers
      expect(serializers.formats).to match_array %i(marshal yaml yml zip)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'configures the serializer providers' do
      serializers = properties.serializers
      expect(serializers.providers.to_a).to match_array [
        [:marshal, Rambling::Trie::Serializers::Marshal],
        [:yaml, Rambling::Trie::Serializers::Yaml],
        [:yml, Rambling::Trie::Serializers::Yaml],
        [:zip, Rambling::Trie::Serializers::Zip],
      ]
    end
    # rubocop:enable RSpec/ExampleLength

    it 'configures the reader formats' do
      readers = properties.readers
      expect(readers.formats).to match_array %i(txt)
    end

    it 'configures the reader providers' do
      readers = properties.readers
      expect(readers.providers.to_a).to match_array [
        [:txt, Rambling::Trie::Readers::PlainText],
      ]
    end

    it 'configures the compressor' do
      compressor = properties.compressor
      expect(compressor).to be_instance_of Rambling::Trie::Compressors::WithGarbageCollection
    end

    it 'configures the root_builder' do
      root = properties.root_builder.call
      expect(root).to be_instance_of Rambling::Trie::Nodes::Raw
    end
  end

  describe '#reset' do
    before do
      properties.serializers.add :test, 'test'
      properties.readers.add :test, 'test'
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'resets the serializers to initial values' do
      expect(properties.serializers.formats).to include :test

      properties.reset

      expect(properties.serializers.formats).not_to include :test
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'resets the readers to initial values' do
      expect(properties.readers.formats).to include :test

      properties.reset

      expect(properties.readers.formats).not_to include :test
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
