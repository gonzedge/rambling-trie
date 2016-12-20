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
end
