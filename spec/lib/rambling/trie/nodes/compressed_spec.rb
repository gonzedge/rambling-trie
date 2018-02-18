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

  describe '#match_prefix' do
    before do
      raw_node.letter = :i
      add_words raw_node, %w(gnite mport mportant mportantly)
    end

    context 'when the node is terminal' do
      before do
        raw_node.terminal!
      end

      it 'adds itself to the words' do
        expect(node.match_prefix %w(g n i t e)).to include 'i'
      end
    end

    context 'when the node is not terminal' do
      it 'does not add itself to the words' do
        expect(node.match_prefix %w(g n i t e)).not_to include 'i'
      end
    end

    context 'when the first few chars match a terminal node' do
      it 'adds those terminal nodes to the words' do
        words = node.match_prefix(%w(m p o r t a n t l y)).to_a
        expect(words).to include 'import', 'important', 'importantly'
      end
    end

    context 'when the first few chars do not match a terminal node' do
      it 'does not add any other words found' do
        words = node.match_prefix(%w(m p m p o r t a n t l y)).to_a
        expect(words).not_to include 'import', 'important', 'importantly'
      end
    end
  end
end
