require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

module Rambling
  describe TrieNode do
    describe 'created with no letters' do
      let(:trie_node) { TrieNode.new '' }

      it 'does not have any letter' do
        trie_node.letter.should be_nil
      end

      it 'includes no children' do
        trie_node.children.should be_empty
      end

      it 'is not a terminal node' do
        trie_node.terminal?.should be_false
      end

      it 'returns empty string as its word' do
        trie_node.as_word.should be_empty
      end

      it 'is not compressed' do
        trie_node.compressed?.should be_false
      end
    end

    describe 'created with one letter' do
      let(:trie_node) { TrieNode.new 'a' }

      it 'makes it the node letter' do
        trie_node.letter.should == :a
      end

      it 'includes no children' do
        trie_node.children.should be_empty
      end

      it 'is a terminal node' do
        trie_node.terminal?.should be_true
      end
    end

    describe 'created with two letters' do
      let(:trie_node) { TrieNode.new 'ba' }

      it 'takes the first as the node letter' do
        trie_node.letter.should == :b
      end

      it 'includes one child' do
        trie_node.children.should_not be_empty
        trie_node.children.length.should == 1
      end

      it 'includes a child with the expected letter' do
        trie_node.children.values.first.letter.should == :a
      end

      it 'has the expected letter as a key' do
        trie_node.has_key?(:a).should be_true
      end

      it 'returns the child corresponding to the key' do
        trie_node[:a].should == trie_node.children[:a]
      end

      it 'does not mark itself as a terminal node' do
        trie_node.terminal?.should be_false
      end

      it 'marks the first child as a terminal node' do
        trie_node[:a].terminal?.should be_true
      end
    end

    describe 'created with a large word' do
      let(:trie_node) { TrieNode.new 'spaghetti' }

      it 'marks the last letter as terminal node' do
        trie_node[:p][:a][:g][:h][:e][:t][:t][:i].terminal?.should be_true
      end

      it 'does not mark any other letter as terminal node' do
        trie_node[:p][:a][:g][:h][:e][:t][:t].terminal?.should be_false
        trie_node[:p][:a][:g][:h][:e][:t].terminal?.should be_false
        trie_node[:p][:a][:g][:h][:e].terminal?.should be_false
        trie_node[:p][:a][:g][:h].terminal?.should be_false
        trie_node[:p][:a][:g].terminal?.should be_false
        trie_node[:p][:a].terminal?.should be_false
        trie_node[:p].terminal?.should be_false
      end
    end

    describe '#add_branch_from' do
      context 'new word for existing branch' do
        let(:trie_node) { TrieNode.new 'back' }

        before :each do
          trie_node.add_branch_from 'a'
        end

        it 'does not increment the child count' do
          trie_node.children.length.should == 1
        end

        it 'marks it as terminal' do
          trie_node[:a].terminal?.should be_true
        end
      end

      context 'old word for existing branch' do
        let(:trie_node) { TrieNode.new 'back' }

        before :each do
          trie_node.add_branch_from 'ack'
        end

        it 'does not increment any child count' do
          trie_node.children.length.should == 1
          trie_node[:a].children.length.should == 1
          trie_node[:a][:c].children.length.should == 1
          trie_node[:a][:c][:k].children.length.should be_zero
        end
      end
    end

    describe '#as_word' do
      context 'for an empty node' do
        let(:trie_node) { TrieNode.new '' }

        it 'returns nil' do
          trie_node.as_word.should be_empty
        end
      end

      context 'for one letter' do
        let(:trie_node) { TrieNode.new 'a' }

        it 'returns the expected one letter word' do
          trie_node.as_word.should == 'a'
        end
      end

      context 'for a small word' do
        let(:trie_node) { TrieNode.new 'all' }

        it 'returns the expected small word' do
          trie_node[:l][:l].as_word.should == 'all'
        end

        it 'raises an error for a non terminal node' do
          lambda { trie_node[:l].as_word }.should raise_error(Rambling::InvalidTrieOperation)
        end
      end

      context 'for a long word' do
        let(:trie_node) { TrieNode.new 'beautiful' }

        it 'returns the expected long word' do
          trie_node[:e][:a][:u][:t][:i][:f][:u][:l].as_word.should == 'beautiful'
        end
      end

      context 'for a node with nil letter' do
        let(:trie_node) { TrieNode.new nil }
        it 'returns nil' do
          trie_node.as_word.should be_empty
        end
      end
    end

    describe '#compressed?' do
      let(:trie) { double('Rambling::Trie') }
      let(:trie_node) { TrieNode.new '', trie }

      context 'parent is compressed' do
        before :each do
          trie.stub(:compressed?).and_return true
        end

        it 'returns true' do
          trie_node.compressed?.should be_true
        end
      end

      context 'parent is not compressed' do
        before :each do
          trie.stub(:compressed?).and_return false
        end

        it 'returns false' do
          trie_node.compressed?.should be_false
        end
      end
    end
  end
end
