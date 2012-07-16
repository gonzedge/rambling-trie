require 'spec_helper'

module Rambling
  module Trie
    describe Node do
      describe '.new' do
        context 'with no letters' do
          let(:node) { Node.new '' }

          it 'does not have any letter' do
            node.letter.should be_nil
          end

          it 'includes no children' do
            node.should have(0).children
          end

          it 'is not a terminal node' do
            node.should_not be_terminal
          end

          it 'returns empty string as its word' do
            node.as_word.should be_empty
          end

          it 'is not compressed' do
            node.should_not be_compressed
          end
        end

        context 'with one letter' do
          let(:node) { Node.new 'a' }

          it 'makes it the node letter' do
            node.letter.should == :a
          end

          it 'includes no children' do
            node.should have(0).children
          end

          it 'is a terminal node' do
            node.should be_terminal
          end
        end

        context 'with two letters' do
          let(:node) { Node.new 'ba' }

          it 'takes the first as the node letter' do
            node.letter.should == :b
          end

          it 'includes one child' do
            node.should have(1).children
          end

          it 'includes a child with the expected letter' do
            node.children.values.first.letter.should == :a
          end

          it 'has the expected letter as a key' do
            node.has_key?(:a).should be_true
          end

          it 'returns the child corresponding to the key' do
            node[:a].should == node.children[:a]
          end

          it 'does not mark itself as a terminal node' do
            node.should_not be_terminal
          end

          it 'marks the first child as a terminal node' do
            node[:a].should be_terminal
          end
        end

        context 'with a large word' do
          let(:node) { Node.new 'spaghetti' }

          it 'marks the last letter as terminal node' do
            node[:p][:a][:g][:h][:e][:t][:t][:i].should be_terminal
          end

          it 'does not mark any other letter as terminal node' do
            node[:p][:a][:g][:h][:e][:t][:t].should_not be_terminal
            node[:p][:a][:g][:h][:e][:t].should_not be_terminal
            node[:p][:a][:g][:h][:e].should_not be_terminal
            node[:p][:a][:g][:h].should_not be_terminal
            node[:p][:a][:g].should_not be_terminal
            node[:p][:a].should_not be_terminal
            node[:p].should_not be_terminal
          end
        end
      end

      describe '#add_branch_from' do
        context 'new word for existing branch' do
          let(:node) { Node.new 'back' }

          before :each do
            node.add_branch_from 'a'
          end

          it 'does not increment the child count' do
            node.should have(1).children
          end

          it 'marks it as terminal' do
            node[:a].should be_terminal
          end
        end

        context 'old word for existing branch' do
          let(:node) { Node.new 'back' }

          before :each do
            node.add_branch_from 'ack'
          end

          it 'does not increment any child count' do
            node.should have(1).children
            node[:a].should have(1).children
            node[:a][:c].should have(1).children
            node[:a][:c][:k].should have(0).children
          end
        end
      end

      describe '#as_word' do
        context 'for an empty node' do
          let(:node) { Node.new '' }

          it 'returns nil' do
            node.as_word.should be_empty
          end
        end

        context 'for one letter' do
          let(:node) { Node.new 'a' }

          it 'returns the expected one letter word' do
            node.as_word.should == 'a'
          end
        end

        context 'for a small word' do
          let(:node) { Node.new 'all' }

          it 'returns the expected small word' do
            node[:l][:l].as_word.should == 'all'
          end

          it 'raises an error for a non terminal node' do
            lambda { node[:l].as_word }.should raise_error(InvalidOperation)
          end
        end

        context 'for a long word' do
          let(:node) { Node.new 'beautiful' }

          it 'returns the expected long word' do
            node[:e][:a][:u][:t][:i][:f][:u][:l].as_word.should == 'beautiful'
          end
        end

        context 'for a node with nil letter' do
          let(:node) { Node.new nil }
          it 'returns nil' do
            node.as_word.should be_empty
          end
        end
      end

      describe '#compressed?' do
        let(:root) { double('Root') }
        let(:node) { Node.new '', root }

        context 'parent is compressed' do
          before :each do
            root.stub(:compressed?).and_return true
          end

          it 'returns true' do
            node.should be_compressed
          end
        end

        context 'parent is not compressed' do
          before :each do
            root.stub(:compressed?).and_return false
          end

          it 'returns false' do
            node.compressed?.should be_false
          end
        end
      end
    end
  end
end
