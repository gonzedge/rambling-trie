# frozen_string_literal: true

require 'spec_helper'
require 'zip'

describe Rambling::Trie do
  let(:assets_path) { File.join ::SPEC_ROOT, 'assets' }

  context 'when providing words directly' do
    it_behaves_like 'a compressible trie' do
      let(:trie) { described_class.create }
      let(:words) { %w(a couple of words for our full trie integration test) }

      before { trie.concat words }
    end
  end

  context 'when provided with words with unicode characters' do
    it_behaves_like 'a compressible trie' do
      let(:trie) { described_class.create }
      let :words do
        %w(poquísimas palabras para nuestra prueba de integración completa 🙃)
      end

      before { trie.concat words }
    end
  end

  context 'when provided with a filepath' do
    let(:trie) { described_class.create filepath }
    let(:words) { File.readlines(filepath).map(&:chomp) }

    context 'with english words' do
      it_behaves_like 'a compressible trie' do
        let(:filepath) { File.join assets_path, 'test_words.en_US.txt' }
      end
    end

    context 'with unicode characters' do
      it_behaves_like 'a compressible trie' do
        let(:filepath) { File.join assets_path, 'test_words.es_DO.txt' }
      end
    end
  end

  describe 'dump and load' do
    let(:words_filepath) { File.join assets_path, 'test_words.en_US.txt' }
    let(:words) { File.readlines(words_filepath).map(&:chomp) }

    context 'when serialized with Ruby marshal format (default)' do
      it_behaves_like 'a serializable trie' do
        let(:trie_to_serialize) { described_class.create words_filepath }
        let(:format) { :marshal }
      end
    end

    context 'when serialized with YAML' do
      it_behaves_like 'a serializable trie' do
        let(:trie_to_serialize) { described_class.create words_filepath }
        let(:format) { :yml }
      end
    end

    context 'when serialized with zipped Ruby marshal format' do
      let!(:original_on_exists_proc) { ::Zip.on_exists_proc }
      let!(:original_continue_on_exists_proc) { ::Zip.continue_on_exists_proc }

      before do
        ::Zip.on_exists_proc = true
        ::Zip.continue_on_exists_proc = true
      end

      after do
        ::Zip.on_exists_proc = original_on_exists_proc
        ::Zip.continue_on_exists_proc = original_continue_on_exists_proc
      end

      it_behaves_like 'a serializable trie' do
        let(:trie_to_serialize) { described_class.create words_filepath }
        let(:format) { 'marshal.zip' }
      end
    end
  end
end
