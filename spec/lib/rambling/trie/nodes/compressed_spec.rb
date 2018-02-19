require 'spec_helper'

describe Rambling::Trie::Nodes::Compressed do
  let(:raw_node) { Rambling::Trie::Nodes::Raw.new }
  let(:compressor) { Rambling::Trie::Compressor.new }
  let(:node) { compressor.compress raw_node }

  it_behaves_like 'a trie node implementation' do
    def add_word_to_tree word
      add_word raw_node, word
    end

    def add_words_to_tree words
      add_words raw_node, words
    end

    def assign_letter letter
      raw_node.letter = letter
    end
  end

  describe '#compressed?' do
    it 'returns true' do
      expect(node).to be_compressed
    end
  end

  describe '#add' do
    it 'raises an error' do
      expect do
        add_word node, 'restaurant'
      end.to raise_error Rambling::Trie::InvalidOperation
    end
  end
end
