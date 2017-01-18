require 'spec_helper'

describe Rambling::Trie do
  shared_examples_for 'a compressable trie' do
    context 'and the trie is not compressed' do
      it_behaves_like 'a trie data structure'

      it 'does not alter the input' do
        word = 'string'
        trie.add word

        expect(word).to eq 'string'
      end

      it 'is marked as not compressed' do
        expect(trie).not_to be_compressed
      end
    end

    context 'and the trie is compressed' do
      before { trie.compress! }

      it_behaves_like 'a trie data structure'

      it 'is marked as compressed' do
        expect(trie).to be_compressed
      end
    end
  end

  shared_examples_for 'a trie data structure' do
    it 'contains all the words from the file' do
      words.each do |word|
        expect(trie).to include word
        expect(trie.word? word).to be true
      end
    end

    it 'matches the start of all the words from the file' do
      words.each do |word|
        expect(trie.match? word).to be true
        expect(trie.match? word[0..-2]).to be true
        expect(trie.partial_word? word).to be true
        expect(trie.partial_word? word[0..-2]).to be true
      end
    end

    it 'allows iterating over all the words' do
      expect(trie.to_a.sort).to eq words.sort
    end
  end

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

  shared_examples_for 'a serializable trie' do
    context 'and the trie is not compressed' do
      before do
        Rambling::Trie.dump trie_to_serialize, trie_filepath, serializer
      end

      it_behaves_like 'a compressable trie' do
        let(:trie) { loaded_trie }
      end
    end

    context 'and the trie is compressed' do
      let(:trie) { loaded_trie }

      before do
        FileUtils.rm_f trie_filepath
        Rambling::Trie.dump trie_to_serialize.compress!, trie_filepath, serializer
      end

      it_behaves_like 'a trie data structure'

      it 'is marked as compressed' do
        expect(trie).to be_compressed
      end
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
        let(:serializer) { Rambling::Trie::Serializers::Yaml.new }
        let(:loaded_trie) { Rambling::Trie.load trie_filepath, serializer }
      end
    end
  end
end
