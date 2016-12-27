require 'spec_helper'

describe Rambling::Trie::CompressedNode do
  let(:node) { Rambling::Trie::CompressedNode.new }

  describe '#compressed?' do
    it 'returns true' do
      expect(node).to be_compressed
    end
  end

  describe '.new' do
    context 'with no parent' do
      let(:node) { Rambling::Trie::CompressedNode.new }

      it 'is marked as root' do
        expect(node).to be_root
      end
    end

    context 'with a specified' do
      let(:node) { Rambling::Trie::CompressedNode.new double(:root) }

      it 'is not marked as root' do
        expect(node).not_to be_root
      end
    end
  end

  describe '#add' do
    it 'raises an error' do
      expect { node.add 'restaurant' }.to raise_error Rambling::Trie::InvalidOperation
    end
  end

  describe '#partial_word?' do
    let(:raw_node) { Rambling::Trie::RawNode.new }
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:node) { compressor.compress raw_node }

    context 'when the chars array is empty' do
      it 'returns true' do
        expect(node.partial_word? []).to be true
      end
    end

    context 'when the chars array is not empty' do
      context 'when the node has a tree that matches the characters' do
        before do
          raw_node.add 'abc'
        end

        it 'returns true' do
          expect(node.partial_word? %w(a)).to be true
          expect(node.partial_word? %w(a b)).to be true
          expect(node.partial_word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match the characters' do
        before do
          raw_node.add 'cba'
        end

        it 'returns false' do
          expect(node.partial_word? %w(a b c)).to be false
        end
      end
    end
  end

  describe '#word?' do
    let(:raw_node) { Rambling::Trie::RawNode.new }
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:node) { compressor.compress raw_node }

    context 'when the chars array is empty' do
      context 'when the node is terminal' do
        before do
          node.terminal!
        end

        it 'returns true' do
          expect(node.word? []).to be true
        end
      end

      context 'when the node is not terminal' do
        it 'returns false' do
          expect(node.word? []).to be false
        end
      end
    end

    context 'when the chars array is not empty' do
      context 'when the node has a tree that matches all the characters' do
        before do
          raw_node.add 'abc'
        end

        it 'returns true' do
          expect(node.word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match all the characters' do
        before do
          raw_node.add 'abc'
        end

        it 'returns false' do
          expect(node.word? %w(a)).to be false
          expect(node.word? %w(a b)).to be false
        end
      end
    end
  end

  describe '#scan' do
    let(:raw_node) { Rambling::Trie::RawNode.new }
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:node) { compressor.compress raw_node }

    context 'when the chars array is empty' do
      it 'returns itself' do
        expect(node.scan []).to eq node
      end
    end

    context 'when the chars array is not empty' do
      before do
        raw_node.add 'cba'
      end

      context 'when the chars are found' do
        it 'returns the found child' do
          expect(node.scan %w(c)).to eq node[:cba]
          expect(node.scan %w(c b)).to eq node[:cba]
          expect(node.scan %w(c b a)).to eq node[:cba]
        end
      end

      context 'when the chars are not found' do
        it 'returns a MissingNode' do
          expect(node.scan %w(a b c)).to be_a Rambling::Trie::MissingNode
        end
      end
    end
  end
end
