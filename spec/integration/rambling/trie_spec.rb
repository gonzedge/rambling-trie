require 'spec_helper'

describe Rambling::Trie do
  describe 'with words provided directly' do
    it_behaves_like 'a compressable trie' do
      let(:words) { %w[a couple of words for our full trie integration test] }
      let(:trie) { Rambling::Trie.create { |t| words.each { |w| t << w } } }
    end
  end

  describe 'with words from a file' do
    it_behaves_like 'a compressable trie' do
      let(:filepath) { File.join ::SPEC_ROOT, 'assets', 'test_words.en_US.txt' }
      let(:words) { File.readlines(filepath).map &:chomp! }
      let(:trie) { Rambling::Trie.create filepath }
    end
  end

  describe 'with words with unicode characters' do
    it_behaves_like 'a compressable trie' do
      let(:words) { %w[poquísimas palabras para nuestra prueba de integración completa] }
      let(:trie) { Rambling::Trie.create { |t| words.each { |w| t << w } } }
    end
  end

  describe 'with words with unicode characters from a file' do
    it_behaves_like 'a compressable trie' do
      let(:filepath) { File.join ::SPEC_ROOT, 'assets', 'test_words.en_US.txt' }
      let(:words) { File.readlines(filepath).map &:chomp! }
      let(:trie) { Rambling::Trie.create filepath }
    end
  end

  describe 'saving and loading full trie from a file' do
    let(:words_filepath) { File.join ::SPEC_ROOT, 'assets', 'test_words.en_US.txt' }
    let(:words) { File.readlines(words_filepath).map &:chomp! }
    let(:trie_to_serialize) { Rambling::Trie.create words_filepath }
    let(:trie_filename) { File.join ::SPEC_ROOT, '..', 'tmp', 'trie-root' }

    context 'when serialized with Ruby marshal format (default)' do
      it_behaves_like 'a serializable trie' do
        let(:trie_filepath) { "#{trie_filename}.marshal" }
        let(:loaded_trie) { Rambling::Trie.load trie_filepath }
        let(:serializer) { nil }
      end
    end

    context 'when serialized with YAML' do
      it_behaves_like 'a serializable trie' do
        let(:trie_filepath) { "#{trie_filename}.yml" }
        let(:loaded_trie) { Rambling::Trie.load trie_filepath }
        let(:serializer) { nil }
      end
    end

    context 'when serialized with zipped Ruby marshal format' do
      before do
        require 'zip'
        @original_on_exists_proc = ::Zip.on_exists_proc
        @original_continue_on_exists_proc = ::Zip.continue_on_exists_proc
        ::Zip.on_exists_proc = true
        ::Zip.continue_on_exists_proc = true
      end

      after do
        require 'zip'
        ::Zip.on_exists_proc = @original_on_exists_proc
        ::Zip.continue_on_exists_proc = @original_continue_on_exists_proc
      end

      it_behaves_like 'a serializable trie' do
        let(:trie_filepath) { "#{trie_filename}.marshal.zip" }
        let(:loaded_trie) { Rambling::Trie.load trie_filepath }
        let(:serializer) { nil }
      end
    end
  end
end
