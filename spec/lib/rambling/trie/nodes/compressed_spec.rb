# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Nodes::Compressed do
  let(:raw_node) { Rambling::Trie::Nodes::Raw.new }
  let(:compressor) { Rambling::Trie::Compressors::WithMergingStrategy.new }
  let(:node) { compressor.compress raw_node }

  describe '#new' do
    it 'is not a word' do
      expect(node).not_to be_word
    end
  end

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
