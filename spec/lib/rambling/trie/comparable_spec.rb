require 'spec_helper'

describe Rambling::Trie::Comparable do
  describe '#==' do
    let(:node_1) { Rambling::Trie::Nodes::Raw.new }
    let(:node_2) { Rambling::Trie::Nodes::Raw.new }

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
        %w(hese hree hings).each do |word|
          node_1.add word.chars.reverse.map(&:to_sym)
        end

        node_2.letter = :t
        %w(hese hree hings).each do |word|
          node_2.add word.chars.reverse.map(&:to_sym)
        end
      end

      it 'returns true' do
        expect(node_1).to eq node_2
        expect(node_1[:h][:e][:s][:e]).to eq node_2[:h][:e][:s][:e]
      end
    end

    context 'when the nodes have the same letter but different children' do
      before do
        node_1.letter = :t
        %w(hese wo).each do |word|
          node_1.add word.chars.reverse.map(&:to_sym)
        end

        node_2.letter = :t
        %w(hese hree hings).each do |word|
          node_2.add word.chars.reverse.map(&:to_sym)
        end
      end

      it 'returns false' do
        expect(node_1).not_to eq node_2
        expect(node_1[:h][:e][:s][:e]).to eq node_2[:h][:e][:s][:e]
      end
    end
  end
end
