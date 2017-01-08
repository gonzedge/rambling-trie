require 'spec_helper'

describe Rambling::Trie::Stringifyable do
  describe '#as_word' do
    let(:node) { Rambling::Trie::RawNode.new }

    context 'for an empty node' do
      before do
        node.add ''
      end

      it 'returns nil' do
        expect(node.as_word).to be_empty
      end
    end

    context 'for one letter' do
      before do
        node.letter = :a
        node.add ''
      end

      it 'returns the expected one letter word' do
        expect(node.as_word).to eq 'a'
      end
    end

    context 'for a small word' do
      before do
        node.letter = :a
        node.add 'll'
      end

      it 'returns the expected small word' do
        expect(node[:l][:l].as_word).to eq 'all'
      end

      it 'raises an error for a non terminal node' do
        expect { node[:l].as_word }.to raise_error Rambling::Trie::InvalidOperation
      end
    end

    context 'for a long word' do
      before do
        node.letter = :b
        node.add 'eautiful'
      end

      it 'returns the expected long word' do
        expect(node[:e][:a][:u][:t][:i][:f][:u][:l].as_word).to eq 'beautiful'
      end
    end

    context 'for a node with nil letter' do
      let(:node) { Rambling::Trie::RawNode.new nil }

      it 'returns nil' do
        expect(node.as_word).to be_empty
      end
    end

    context 'for a compressed node' do
      let(:compressor) { Rambling::Trie::Compressor.new }
      let(:compressed_node) { compressor.compress node }

      before do
        node.letter = :a
        node.add 'm'
        node.add 'dd'
      end

      it 'returns the words for the terminal nodes' do
        expect(compressed_node[:m].as_word).to eq 'am'
        expect(compressed_node[:dd].as_word).to eq 'add'
      end

      it 'raise an error for non terminal nodes' do
        expect { compressed_node.as_word }.to raise_error Rambling::Trie::InvalidOperation
      end
    end
  end
end
