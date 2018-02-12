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
      expect { node.add %i(r e s t a u r a n t) }.to raise_error Rambling::Trie::InvalidOperation
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
          raw_node.add %i(a b c)
        end

        it 'returns true' do
          expect(node.partial_word? %w(a)).to be true
          expect(node.partial_word? %w(a b)).to be true
          expect(node.partial_word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match the characters' do
        before do
          raw_node.add %i(c b a)
        end

        it 'returns false' do
          expect(node.partial_word? %w(a)).to be false
          expect(node.partial_word? %w(a b)).to be false
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
          raw_node.add %i(a b c)
        end

        it 'returns true' do
          expect(node.word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match all the characters' do
        before do
          raw_node.add %i(a b c)
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
        raw_node.add %i(c b a)
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
          expect(node.scan %w(a)).to be_a Rambling::Trie::MissingNode
          expect(node.scan %w(a b)).to be_a Rambling::Trie::MissingNode
          expect(node.scan %w(a b c)).to be_a Rambling::Trie::MissingNode
          expect(node.scan %w(c b a d)).to be_a Rambling::Trie::MissingNode
        end
      end
    end
  end

  describe '#match_prefix' do
    let(:raw_node) { Rambling::Trie::RawNode.new }
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:node) { compressor.compress raw_node }

    before do
      raw_node.letter = :i
      raw_node.add %i(g n i t e)
      raw_node.add %i(m p o r t)
      raw_node.add %i(m p o r t a n t)
      raw_node.add %i(m p o r t a n t l y)
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
