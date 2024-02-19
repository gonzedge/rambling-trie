# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie do
  describe '.create' do
    let(:root) { Rambling::Trie::Nodes::Raw.new }
    let(:compressor) { Rambling::Trie::Compressor.new }
    let!(:container) { Rambling::Trie::Container.new root, compressor }

    before do
      allow(Rambling::Trie::Container).to receive(:new)
        .and_yield(container)
        .and_return container
    end

    it 'returns a new instance of the trie container' do
      expect(described_class.create).to eq container
    end

    context 'with a block' do
      it 'yields the new container' do
        yielded = nil
        described_class.create { |trie| yielded = trie }
        expect(yielded).to eq container
      end
    end

    context 'with a filepath' do
      let(:filepath) { 'a test filepath' }
      let :reader do
        instance_double Rambling::Trie::Readers::PlainText, :reader
      end
      let(:words) { %w(a couple of test words over here) }

      before do
        receive_and_yield = receive(:each_word)
        words.inject receive_and_yield do |yielder, word|
          yielder.and_yield word
        end

        allow(reader).to receive_and_yield
        allow(container).to receive :<<
      end

      it 'loads every word' do
        described_class.create filepath, reader

        words.each do |word|
          expect(container).to have_received(:<<).with word
        end
      end
    end

    context 'without any reader' do
      let(:filepath) { 'a test filepath' }
      let :reader do
        instance_double(
          Rambling::Trie::Readers::PlainText,
          :reader,
          each_word: nil,
        )
      end

      before do
        described_class.config do |c|
          c.readers.add :default, reader
          c.readers.default = reader
        end
      end

      it 'defaults to a plain text reader' do
        described_class.create filepath, nil

        expect(reader).to have_received(:each_word).with filepath
      end
    end
  end

  describe '.load' do
    let(:filepath) { 'a path to a file' }
    let(:root) { Rambling::Trie::Nodes::Raw.new }
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:container) { Rambling::Trie::Container.new root, compressor }
    let :serializer do
      instance_double(
        Rambling::Trie::Serializers::File,
        :serializer,
        load: root,
      )
    end

    it 'returns a new container with the loaded root node' do
      trie = described_class.load filepath, serializer
      expect(trie).to eq container
    end

    it 'uses the serializer to load the root node from the given filepath' do
      described_class.load filepath, serializer
      expect(serializer).to have_received(:load).with filepath
    end

    context 'without a serializer' do
      let :marshal_serializer do
        instance_double(
          Rambling::Trie::Serializers::Marshal,
          :marshal_serializer,
          load: nil,
        )
      end
      let :default_serializer do
        instance_double(
          Rambling::Trie::Serializers::File,
          :default_serializer,
          load: nil,
        )
      end
      let :yaml_serializer do
        instance_double(
          Rambling::Trie::Serializers::Yaml,
          :yaml_serializer,
          load: nil,
        )
      end

      before do
        described_class.config do |c|
          c.serializers.add :default, default_serializer
          c.serializers.add :marshal, marshal_serializer
          c.serializers.add :yml, yaml_serializer
          c.serializers.add :yaml, yaml_serializer

          c.serializers.default = default_serializer
        end
      end

      [
        ['.marshal', :marshal_serializer],
        ['.yml', :yaml_serializer],
        ['.yaml', :yaml_serializer],
        ['', :default_serializer],
      ].each do |test_params|
        extension, serializer = test_params
        filepath = "test#{extension}"

        it "uses extension-based serializer (#{filepath} -> #{serializer})" do
          serializer_instance = public_send serializer

          described_class.load filepath
          expect(serializer_instance).to have_received(:load).with filepath
        end
      end
    end

    context 'with a block' do
      it 'yields the new container' do
        yielded = nil

        described_class.load filepath, serializer do |trie|
          yielded = trie
        end

        expect(yielded).to eq container
      end
    end
  end

  describe '.dump' do
    let(:filename) { 'a trie' }
    let(:root) { instance_double Rambling::Trie::Serializers::Marshal, :root }
    let :compressor do
      instance_double Rambling::Trie::Serializers::Marshal, :compressor
    end
    let(:trie) { Rambling::Trie::Container.new root, compressor }

    let :marshal_serializer do
      instance_double(
        Rambling::Trie::Serializers::Marshal,
        :marshal_serializer,
        dump: nil,
      )
    end
    let :yaml_serializer do
      instance_double(
        Rambling::Trie::Serializers::Yaml,
        :yaml_serializer,
        dump: nil,
      )
    end
    let :default_serializer do
      instance_double(
        Rambling::Trie::Serializers::File,
        :default_serializer,
        dump: nil,
      )
    end

    before do
      described_class.config do |c|
        c.serializers.add :default, default_serializer
        c.serializers.add :marshal, marshal_serializer
        c.serializers.add :yml, yaml_serializer

        c.serializers.default = default_serializer
      end
    end

    it 'uses the configured default serializer by default' do
      described_class.dump trie, filename
      expect(default_serializer).to have_received(:dump).with root, filename
    end

    context 'when provided with a format' do
      [
        ['.marshal', :marshal_serializer],
        ['.yml', :yaml_serializer],
        ['', :default_serializer],
      ].each do |test_params|
        extension, serializer = test_params

        it 'uses the corresponding serializer' do
          filepath = "#{filename}#{extension}"
          serializer_instance = public_send serializer

          described_class.dump trie, filepath
          expect(serializer_instance).to have_received(:dump)
            .with root, filepath
        end
      end
    end
  end

  describe '.config' do
    it 'returns the properties' do
      expect(described_class.config).to eq described_class.send :properties
    end

    it 'yields the properties' do
      yielded = nil
      described_class.config { |c| yielded = c }
      expect(yielded).to eq described_class.send :properties
    end
  end
end
