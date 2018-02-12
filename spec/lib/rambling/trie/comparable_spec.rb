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

    context 'when the nodes have the same letter and are terminal' do
      before do
        node_1.letter = :a
        node_1.terminal!

        node_2.letter = :a
        node_2.terminal!
      end

      it 'returns true' do
        expect(node_1).to eq node_2
      end
    end

    context 'when the nodes have the same letter and are not terminal' do
      before do
        node_1.letter = :a
        node_2.letter = :a
      end

      it 'returns true' do
        expect(node_1).to eq node_2
      end
    end

    context 'when the nodes have the same letter but are not both terminal' do
      before do
        node_1.letter = :a
        node_1.terminal!

        node_2.letter = :a
      end
      it 'returns false' do
        expect(node_1).not_to eq node_2
      end
    end

    context 'when the nodes have the same letter and the same children' do
      before do
        node_1.letter = :t
        node_1.add %i(h e s e)
        node_1.add %i(h r e e)
        node_1.add %i(h i n g s)

        node_2.letter = :t
        node_2.add %i(h e s e)
        node_2.add %i(h r e e)
        node_2.add %i(h i n g s)
      end

      it 'returns true' do
        expect(node_1).to eq node_2
        expect(node_1[:h][:e][:s][:e]).to eq node_2[:h][:e][:s][:e]
      end
    end

    context 'when the nodes have the same letter but different children' do
      before do
        node_1.letter = :t
        node_1.add %i(h e s e)
        node_1.add %i(w o)

        node_2.letter = :t
        node_2.add %i(h e s e)
        node_2.add %i(h r e e)
        node_2.add %i(h i n g s)
      end

      it 'returns false' do
        expect(node_1).not_to eq node_2
        expect(node_1[:h][:e][:s][:e]).to eq node_2[:h][:e][:s][:e]
      end
    end
  end
end
