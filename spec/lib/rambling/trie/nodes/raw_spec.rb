# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Nodes::Raw do
  let(:node) { described_class.new }

  describe '#new' do
    it 'is not a word' do
      expect(node).not_to be_word
    end
  end

  it_behaves_like 'a trie node implementation' do
    def add_word_to_tree word
      add_word node, word
    end

    def add_words_to_tree words
      add_words node, words
    end

    def assign_letter letter
      node.letter = letter
    end
  end

  describe '#compressed?' do
    it 'returns false' do
      expect(node).not_to be_compressed
    end
  end

  describe '#add' do
    context 'when the node has no branches' do
      before { add_word node, 'abc' }

      it 'adds only one child' do
        expect(node.children.size).to eq 1
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'adds the full subtree' do
        expect(node[:a]).not_to be_nil
        expect(node[:a][:b]).not_to be_nil
        expect(node[:a][:b][:c]).not_to be_nil
      end
      # rubocop:enable RSpec/MultipleExpectations

      # rubocop:disable RSpec/MultipleExpectations
      it 'marks only the last child as terminal' do
        expect(node).not_to be_terminal
        expect(node[:a]).not_to be_terminal
        expect(node[:a][:b]).not_to be_terminal
        expect(node[:a][:b][:c]).to be_terminal
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when a word is added more than once' do
      before do
        add_word node, 'ack'
        add_word node, 'ack'
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'only counts it once' do
        expect(node.children.size).to eq 1
        expect(node[:a].children.size).to eq 1
        expect(node[:a][:c].children.size).to eq 1
        expect(node[:a][:c][:k].children.size).to eq 0
      end
      # rubocop:enable RSpec/MultipleExpectations

      # rubocop:disable RSpec/MultipleExpectations
      it 'does not change the terminal nodes in the tree' do
        expect(node).not_to be_terminal
        expect(node[:a]).not_to be_terminal
        expect(node[:a][:c]).not_to be_terminal
        expect(node[:a][:c][:k]).to be_terminal
      end
      # rubocop:enable RSpec/MultipleExpectations

      it 'still returns the "added" node' do
        child = add_word node, 'ack'
        expect(child.letter).to eq :a
      end
    end

    context 'when the word does not exist in the tree but the letters do' do
      before { add_words node, %w(ack a) }

      it 'does not add another branch' do
        expect(node.children.size).to eq 1
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'marks the corresponding node as terminal' do
        expect(node).not_to be_terminal
        expect(node[:a]).to be_terminal
        expect(node[:a][:c]).not_to be_terminal
        expect(node[:a][:c][:k]).to be_terminal
      end
      # rubocop:enable RSpec/MultipleExpectations

      it 'returns the added node' do
        child = add_word node, 'a'
        expect(child.letter).to eq :a
      end
    end

    context 'when the node has a letter and a parent' do
      let(:parent) { described_class.new }
      let(:node) { described_class.new :a, parent }

      context 'when adding an empty string' do
        before { add_word node, '' }

        it 'does not alter the node letter' do
          expect(node.letter).to eq :a
        end

        it 'does not change the node children' do
          expect(node.children.size).to eq 0
        end

        it 'changes the node to terminal' do
          expect(node).to be_terminal
        end
      end

      context 'when adding a one letter word' do
        before { add_word node, 'b' }

        it 'does not alter the node letter' do
          expect(node.letter).to eq :a
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'adds a child with the expected letter' do
          expect(node.children.size).to eq 1
          expect(node.children.first.letter).to eq :b
        end
        # rubocop:enable RSpec/MultipleExpectations

        it 'reports it has the expected letter a key' do
          expect(node).to have_key(:b)
        end

        it 'returns the child corresponding to the key' do
          expect(node[:b]).to eq node.children_tree[:b]
        end

        it 'does not mark itself as terminal' do
          expect(node).not_to be_terminal
        end

        it 'marks the first child as terminal' do
          expect(node[:b]).to be_terminal
        end
      end

      context 'when adding a large word' do
        before { add_word node, 'mplified' }

        it 'marks the last letter as terminal' do
          expect(node[:m][:p][:l][:i][:f][:i][:e][:d]).to be_terminal
        end

        # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
        it 'does not mark any other letter as terminal' do
          expect(node[:m][:p][:l][:i][:f][:i][:e]).not_to be_terminal
          expect(node[:m][:p][:l][:i][:f][:i]).not_to be_terminal
          expect(node[:m][:p][:l][:i][:f]).not_to be_terminal
          expect(node[:m][:p][:l][:i]).not_to be_terminal
          expect(node[:m][:p][:l]).not_to be_terminal
          expect(node[:m][:p]).not_to be_terminal
          expect(node[:m]).not_to be_terminal
        end
        # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
      end
    end
  end
end
