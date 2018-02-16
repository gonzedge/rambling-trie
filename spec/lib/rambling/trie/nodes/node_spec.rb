require 'spec_helper'

describe Rambling::Trie::Nodes::Node do
  let(:node) { Rambling::Trie::Nodes::Node.new }

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
    let(:node) { Rambling::Trie::Nodes::Node.new }

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

  describe '#terminal!' do
    it 'forces the node to be terminal' do
      expect(node).not_to be_terminal
      node.terminal!

      expect(node).to be_terminal
    end

    it 'returns the node' do
      expect(node.terminal!).to eq node
    end
  end

  describe 'delegates and aliases' do
    let(:children_tree) do
      double :children_tree, {
        :[] => 'value',
        :[]= => nil,
        has_key?: false,
        delete: true,
      }
    end

    before do
      node.children_tree = children_tree
    end

    it 'delegates `#[]` to its children tree' do
      expect(node[:key]).to eq 'value'
      expect(children_tree).to have_received(:[]).with :key
    end

    it 'delegates `#[]=` to its children tree' do
      node[:key] = 'value'
      expect(children_tree).to have_received(:[]=).with(:key, 'value')
    end

    it 'delegates `#has_key?` to its children tree' do
      allow(children_tree).to receive(:has_key?).with(:present_key).and_return true

      expect(node).to have_key(:present_key)
      expect(node).not_to have_key(:absent_key)
    end

    it 'delegates `#delete` to its children tree' do
      expect(node.delete :key).to be true
      expect(children_tree).to have_received(:delete).with :key
    end

    it 'delegates `#children` to its children tree values' do
      children = [double(:child_1), double(:child_2)]
      allow(children_tree).to receive(:values).and_return children

      expect(node.children).to eq children
    end
  end
end
