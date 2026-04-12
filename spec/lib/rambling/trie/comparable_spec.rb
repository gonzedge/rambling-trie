# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Comparable do
  describe '#==' do
    let(:node_one) { Rambling::Trie::Nodes::Raw.new }
    let(:node_two) { Rambling::Trie::Nodes::Raw.new }

    context 'when the nodes do not have the same letter' do
      before do
        node_one.letter = :a
        node_two.letter = :b
      end

      it 'returns false' do
        expect(node_one).not_to eq node_two
      end
    end

    context 'when nodes have same letter, not terminal and no children' do
      before do
        node_one.letter = :a
        node_two.letter = :a
      end

      it 'returns true' do
        expect(node_one).to eq node_two
      end
    end

    context 'when the nodes have the same letter and are terminal' do
      before do
        node_one.letter = :a
        node_one.terminal!

        node_two.letter = :a
        node_two.terminal!
      end

      it 'returns true' do
        expect(node_one).to eq node_two
      end
    end

    context 'when the nodes have the same letter but are not both terminal' do
      before do
        node_one.letter = :a
        node_one.terminal!

        node_two.letter = :a
      end

      it 'returns false' do
        expect(node_one).not_to eq node_two
      end
    end

    context 'when the nodes have the same letter and the same children' do
      before do
        node_one.letter = :t
        add_words node_one, %w(hese hree hings)

        node_two.letter = :t
        add_words node_two, %w(hese hree hings)
      end

      it 'returns true' do
        expect(node_one).to eq node_two
      end
    end

    context 'when the nodes have the same letter but different children' do
      before do
        node_one.letter = :t
        add_words node_one, %w(hese wo)

        node_two.letter = :t
        add_words node_two, %w(hese hree hings)
      end

      it 'returns false' do
        expect(node_one).not_to eq node_two
      end
    end

    context 'when nodes are otherwise identical but have different values' do
      before do
        node_one.letter = :a
        node_one.terminal!
        node_one.value = 1

        node_two.letter = :a
        node_two.terminal!
        node_two.value = 2
      end

      it 'returns false' do
        expect(node_one).not_to eq node_two
      end
    end

    context 'when nodes are identical including the same value' do
      before do
        node_one.letter = :a
        node_one.terminal!
        node_one.value = :same

        node_two.letter = :a
        node_two.terminal!
        node_two.value = :same
      end

      it 'returns true' do
        expect(node_one).to eq node_two
      end
    end

    context 'when nodes have the same structure but one has a value and the other does not' do
      before do
        node_one.letter = :a
        node_one.terminal!
        node_one.value = 42

        node_two.letter = :a
        node_two.terminal!
      end

      it 'returns false' do
        expect(node_one).not_to eq node_two
      end
    end
  end
end
