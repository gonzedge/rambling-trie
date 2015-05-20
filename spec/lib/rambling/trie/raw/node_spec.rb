require 'spec_helper'

describe Rambling::Trie::Raw::Node do
  let(:node) { Rambling::Trie::Raw::Node.new }

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
end
