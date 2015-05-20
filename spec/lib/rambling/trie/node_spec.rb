require 'spec_helper'

describe Rambling::Trie::Node do
  let(:node) { Rambling::Trie::Node.new }

  describe '#root?' do
    context 'when the node has a parent' do
      before do
        node.parent = double :parent
      end

      it 'returns false' do
        expect(node).not_to be_root
      end
    end

    context 'when the node does not have a parent' do
      before do
        node.parent = nil
      end

      it 'returns true' do
        expect(node).to be_root
      end
    end
  end

  describe '.new' do
    context 'with no word' do
      let(:node) { Rambling::Trie::Node.new }

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

      it 'is not compressed' do
        expect(node).not_to be_compressed
      end
    end

    context 'with an empty word' do
      let(:node) { Rambling::Trie::Node.new '' }

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

      it 'is not compressed' do
        expect(node).not_to be_compressed
      end
    end

    context 'with one letter' do
      let(:node) { Rambling::Trie::Node.new 'a' }

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

    context 'with two letters' do
      let(:node) { Rambling::Trie::Node.new 'ba' }

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
      let(:node) { Rambling::Trie::Node.new 'spaghetti' }

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
  end

  describe '#as_word' do
    context 'for an empty node' do
      let(:node) { Rambling::Trie::Node.new '' }

      it 'returns nil' do
        expect(node.as_word).to be_empty
      end
    end

    context 'for one letter' do
      let(:node) { Rambling::Trie::Node.new 'a' }

      it 'returns the expected one letter word' do
        expect(node.as_word).to eq 'a'
      end
    end

    context 'for a small word' do
      let(:node) { Rambling::Trie::Node.new 'all' }

      it 'returns the expected small word' do
        expect(node[:l][:l].as_word).to eq 'all'
      end

      it 'raises an error for a non terminal node' do
        expect { node[:l].as_word }.to raise_error Rambling::Trie::InvalidOperation
      end
    end

    context 'for a long word' do
      let(:node) { Rambling::Trie::Node.new 'beautiful' }

      it 'returns the expected long word' do
        expect(node[:e][:a][:u][:t][:i][:f][:u][:l].as_word).to eq 'beautiful'
      end
    end

    context 'for a node with nil letter' do
      let(:node) { Rambling::Trie::Node.new nil }
      it 'returns nil' do
        expect(node.as_word).to be_empty
      end
    end
  end

  describe '#compressed?' do
    let(:root) { double :root }
    let(:node) { Rambling::Trie::Node.new '', root }

    context 'parent is compressed' do
      before do
        allow(root).to receive(:compressed?).and_return true
      end

      it 'returns true' do
        expect(node).to be_compressed
      end
    end

    context 'parent is not compressed' do
      before do
        allow(root).to receive(:compressed?).and_return false
      end

      it 'returns false' do
        expect(node).not_to be_compressed
      end
    end
  end

  describe 'delegates and aliases' do
    it 'delegates `#[]` to its children tree' do
      expect(node.children_tree).to receive(:[]).with(:key).and_return('value')
      expect(node[:key]).to eq 'value'
    end

    it 'delegates `#[]=` to its children tree' do
      expect(node.children_tree).to receive(:[]=).with(:key, 'value')
      node[:key] = 'value'
    end

    it 'delegates `#delete` to its children tree' do
      expect(node.children_tree).to receive(:delete).with(:key).and_return('value')
      expect(node.delete :key).to eq 'value'
    end

    it 'delegates `#has_key?` to its children tree' do
      expect(node.children_tree).to receive(:has_key?).with(:present_key).and_return(true)
      expect(node).to have_key(:present_key)

      expect(node.children_tree).to receive(:has_key?).with(:absent_key).and_return(false)
      expect(node).not_to have_key(:absent_key)
    end

    it 'delegates `#children` to its children tree values' do
      children = [double(:child_1), double(:child_2)]
      expect(node.children_tree).to receive(:values).and_return(children)
      expect(node.children).to eq children
    end
  end
end
