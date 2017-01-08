require 'spec_helper'

describe Rambling::Trie::RawNode do
  let(:node) { Rambling::Trie::RawNode.new }

  describe '#compressed?' do
    it 'returns false' do
      expect(node).not_to be_compressed
    end
  end

  describe '.new' do
    context 'with no word' do
      let(:node) { Rambling::Trie::RawNode.new }

      it 'does not have any letter' do
        expect(node.letter).to be_nil
      end

      it 'includes no children' do
        expect(node.children.size).to eq 0
      end

      it 'is not a terminal node' do
        expect(node).not_to be_terminal
      end

      it 'returns empty string as its word' do
        expect(node.as_word).to be_empty
      end
    end

    describe '#letter=' do
      let(:parent) { Rambling::Trie::RawNode.new }
      let(:node) { Rambling::Trie::RawNode.new parent }

      context 'with empty string' do
        before do
          node.letter = :a
          node.add ''
        end

        it 'makes it the node letter' do
          expect(node.letter).to eq :a
        end

        it 'includes no children' do
          expect(node.children.size).to eq 0
        end

        it 'is a terminal node' do
          expect(node).to be_terminal
        end
      end

      context 'with one letter' do
        before do
          node.letter = :b
          node.add 'a'
        end

        it 'takes the first as the node letter' do
          expect(node.letter).to eq :b
        end

        it 'includes one child' do
          expect(node.children.size).to eq 1
        end

        it 'includes a child with the expected letter' do
          expect(node.children.first.letter).to eq :a
        end

        it 'has the expected letter as a key' do
          expect(node).to have_key(:a)
        end

        it 'returns the child corresponding to the key' do
          expect(node[:a]).to eq node.children_tree[:a]
        end

        it 'does not mark itself as a terminal node' do
          expect(node).not_to be_terminal
        end

        it 'marks the first child as a terminal node' do
          expect(node[:a]).to be_terminal
        end
      end

      context 'with a large word' do
        before do
          node.letter = :s
          node.add 'paghetti'
        end

        it 'marks the last letter as terminal node' do
          expect(node[:p][:a][:g][:h][:e][:t][:t][:i]).to be_terminal
        end

        it 'does not mark any other letter as terminal node' do
          expect(node[:p][:a][:g][:h][:e][:t][:t]).not_to be_terminal
          expect(node[:p][:a][:g][:h][:e][:t]).not_to be_terminal
          expect(node[:p][:a][:g][:h][:e]).not_to be_terminal
          expect(node[:p][:a][:g][:h]).not_to be_terminal
          expect(node[:p][:a][:g]).not_to be_terminal
          expect(node[:p][:a]).not_to be_terminal
          expect(node[:p]).not_to be_terminal
        end
      end

      context 'with no parent' do
        before do
          node.letter = :a
          node.add ''
        end

        it 'makes it the node letter' do
          expect(node.letter).to eq :a
        end

        it 'includes no children' do
          expect(node.children.size).to eq 0
        end

        it 'is a terminal node' do
          expect(node).to be_terminal
        end
      end
    end

    context 'with no parent' do
      let(:node) { Rambling::Trie::RawNode.new }

      it 'is marked as root' do
        expect(node).to be_root
      end
    end

    context 'with a specified parent' do
      let(:node) { Rambling::Trie::RawNode.new double(:root) }

      it 'is not marked as root' do
        expect(node).not_to be_root
      end
    end

    it 'has no children' do
      expect(node.children.size).to eq 0
    end

    it 'has no letter' do
      expect(node.letter).to be_nil
    end

    it 'is not a terminal node' do
      expect(node).not_to be_terminal
    end

    it 'is not a word' do
      expect(node).not_to be_word
    end
  end

  describe '#add' do
    context 'when the node has no branches' do
      before do
        node.add 'abc'
      end

      it 'adds only one child' do
        expect(node.children.size).to eq 1
      end

      it 'adds the full subtree' do
        expect(node[:a]).not_to be_nil
        expect(node[:a][:b]).not_to be_nil
        expect(node[:a][:b][:c]).not_to be_nil
      end

      it 'marks only the last child as terminal' do
        expect(node).not_to be_terminal
        expect(node[:a]).not_to be_terminal
        expect(node[:a][:b]).not_to be_terminal
        expect(node[:a][:b][:c]).to be_terminal
      end
    end

    context 'when the word being added already exists in the node' do
      before do
        node.add 'ack'
      end

      it 'does not increment any child count in the tree' do
        node.add 'ack'

        expect(node.children.size).to eq 1
        expect(node[:a].children.size).to eq 1
        expect(node[:a][:c].children.size).to eq 1
        expect(node[:a][:c][:k].children.size).to eq 0
      end

      it 'does not mark any child as terminal in the tree' do
        node.add 'ack'

        expect(node).not_to be_terminal
        expect(node[:a]).not_to be_terminal
        expect(node[:a][:c]).not_to be_terminal
        expect(node[:a][:c][:k]).to be_terminal
      end

      it 'returns the added node' do
        expect(node.add('ack').letter).to eq :a
      end
    end

    context 'when the word does not exist in the tree but the letters do' do
      before do
        node.add 'ack'
      end

      it 'does not add another branch' do
        node.add 'a'
        expect(node.children.size).to eq 1
      end

      it 'marks the corresponding node as terminal' do
        node.add 'a'

        expect(node).not_to be_terminal
        expect(node[:a]).to be_terminal
        expect(node[:a][:c]).not_to be_terminal
        expect(node[:a][:c][:k]).to be_terminal
      end

      it 'returns the added node' do
        expect(node.add('a').letter).to eq :a
      end
    end
  end

  describe '#partial_word?' do
    context 'when the chars array is empty' do
      it 'returns true' do
        expect(node.partial_word? []).to be true
      end
    end

    context 'when the chars array is not empty' do
      context 'when the node has a tree that matches the characters' do
        before do
          node.add 'abc'
        end

        it 'returns true' do
          expect(node.partial_word? %w(a)).to be true
          expect(node.partial_word? %w(a b)).to be true
          expect(node.partial_word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match the characters' do
        before do
          node.add 'cba'
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
          node.add 'abc'
        end

        it 'returns true' do
          expect(node.word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match all the characters' do
        before do
          node.add 'abc'
        end

        it 'returns false' do
          expect(node.word? %w(a)).to be false
          expect(node.word? %w(a b)).to be false
        end
      end
    end
  end

  describe '#scan' do
    context 'when the chars array is empty' do
      it 'returns itself' do
        expect(node.scan []).to eq node
      end
    end

    context 'when the chars array is not empty' do
      before do
        node.add 'cba'
      end

      context 'when the chars are found' do
        it 'returns the found child' do
          expect(node.scan %w(c)).to eq node[:c]
          expect(node.scan %w(c b)).to eq node[:c][:b]
          expect(node.scan %w(c b a)).to eq node[:c][:b][:a]
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
end
