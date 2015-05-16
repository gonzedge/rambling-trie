require 'spec_helper'

describe Rambling::Trie do
  shared_examples_for 'a compressable trie' do
    context 'and the trie is not compressed' do
      it_behaves_like 'a trie data structure'
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
      let(:trie) { Rambling::Trie.create }

      before do
        words.each do |word|
          trie << word
          trie.add word
        end
      end
    end
  end

  describe 'with words from a file' do
    it_behaves_like 'a compressable trie' do
      let(:filepath) { File.join ::SPEC_ROOT, 'assets', 'test_words.txt' }
      let(:words) { File.readlines(filepath).map &:chomp }
      let(:trie) { Rambling::Trie.create filepath }
    end
  end
end
