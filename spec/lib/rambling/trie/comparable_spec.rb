require 'spec_helper'

describe Rambling::Trie::Comparable do
  describe '#==' do
    let(:node_1) { Rambling::Trie::RawNode.new }
    let(:node_2) { Rambling::Trie::RawNode.new }

    context 'when the nodes do not have the same letter' do
      before do
        node_1.letter = :a
        node_2.letter = :b
      end

      it 'returns false' do
        expect(node_1).not_to eq node_2
      end
    end

    context 'when the nodes have the same letter and no children' do
      before do
        node_1.letter = :a
        node_2.letter = :a
      end

      it 'returns true' do
        expect(node_1).to eq node_2
      end
    end

    context 'when the nodes have the same letter and the same children' do
      before do
        node_1.letter = :t
        node_1.add 'hese'
        node_1.add 'hree'
        node_1.add 'hings'

        node_2.letter = :t
        node_2.add 'hese'
        node_2.add 'hree'
        node_2.add 'hings'
      end

      it 'returns true' do
        expect(node_1).to eq node_2
      end
    end

    context 'when the nodes have the same letter and the same children' do
      before do
        node_1.letter = :t
        node_1.add 'hese'
        node_1.add 'wo'

        node_2.letter = :t
        node_2.add 'hese'
        node_2.add 'hree'
        node_2.add 'hings'
      end

      it 'returns false' do
        expect(node_1).not_to eq node_2
      end
    end
  end
end
