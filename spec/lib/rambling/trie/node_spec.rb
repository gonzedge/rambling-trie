require 'spec_helper'

module Rambling
  module Trie
    describe Node do
      it 'delegates `#[]` to its children tree' do
        subject.children_tree.should_receive(:[]).with(:key).and_return('value')
        expect(subject[:key]).to eq 'value'
      end

      it 'delegates `#[]=` to its children tree' do
        subject.children_tree.should_receive(:[]=).with(:key, 'value')
        subject[:key] = 'value'
      end

      it 'delegates `#delete` to its children tree' do
        subject.children_tree.should_receive(:delete).with(:key).and_return('value')
        expect(subject.delete :key).to eq 'value'
      end

      it 'delegates `#has_key?` to its children tree' do
        subject.children_tree.should_receive(:has_key?).with(:present_key).and_return(true)
        expect(subject).to have_key(:present_key)

        subject.children_tree.should_receive(:has_key?).with(:absent_key).and_return(false)
        expect(subject).not_to have_key(:absent_key)
      end

      it 'delegates `#children` to its children tree values' do
        children = [double('child 1'), double('child 2')]
        subject.children_tree.should_receive(:values).and_return(children)
        expect(subject.children).to eq children
      end

      describe '#root?' do
        it 'returns false' do
          expect(subject).to_not be_root
        end
      end

      describe '.new' do
        context 'with no word' do
          subject { Node.new }

          it 'does not have any letter' do
            expect(subject.letter).to be_nil
          end

          it 'includes no children' do
            expect(subject).to have(0).children
          end

          it 'is not a terminal node' do
            expect(subject).to_not be_terminal
          end

          it 'returns empty string as its word' do
            expect(subject.as_word).to be_empty
          end

          it 'is not compressed' do
            expect(subject).to_not be_compressed
          end
        end

        context 'with an empty word' do
          subject { Node.new '' }

          it 'does not have any letter' do
            expect(subject.letter).to be_nil
          end

          it 'includes no children' do
            expect(subject).to have(0).children
          end

          it 'is not a terminal node' do
            expect(subject).to_not be_terminal
          end

          it 'returns empty string as its word' do
            expect(subject.as_word).to be_empty
          end

          it 'is not compressed' do
            expect(subject).to_not be_compressed
          end
        end

        context 'with one letter' do
          subject { Node.new 'a' }

          it 'makes it the node letter' do
            expect(subject.letter).to eq :a
          end

          it 'includes no children' do
            expect(subject).to have(0).children
          end

          it 'is a terminal node' do
            expect(subject).to be_terminal
          end
        end

        context 'with two letters' do
          subject { Node.new 'ba' }

          it 'takes the first as the node letter' do
            expect(subject.letter).to eq :b
          end

          it 'includes one child' do
            expect(subject).to have(1).children
          end

          it 'includes a child with the expected letter' do
            expect(subject.children.first.letter).to eq :a
          end

          it 'has the expected letter as a key' do
            expect(subject).to have_key(:a)
          end

          it 'returns the child corresponding to the key' do
            expect(subject[:a]).to eq subject.children_tree[:a]
          end

          it 'does not mark itself as a terminal node' do
            expect(subject).to_not be_terminal
          end

          it 'marks the first child as a terminal node' do
            expect(subject[:a]).to be_terminal
          end
        end

        context 'with a large word' do
          subject { Node.new 'spaghetti' }

          it 'marks the last letter as terminal node' do
            expect(subject[:p][:a][:g][:h][:e][:t][:t][:i]).to be_terminal
          end

          it 'does not mark any other letter as terminal node' do
            expect(subject[:p][:a][:g][:h][:e][:t][:t]).to_not be_terminal
            expect(subject[:p][:a][:g][:h][:e][:t]).to_not be_terminal
            expect(subject[:p][:a][:g][:h][:e]).to_not be_terminal
            expect(subject[:p][:a][:g][:h]).to_not be_terminal
            expect(subject[:p][:a][:g]).to_not be_terminal
            expect(subject[:p][:a]).to_not be_terminal
            expect(subject[:p]).to_not be_terminal
          end
        end
      end

      describe '#as_word' do
        context 'for an empty node' do
          subject { Node.new '' }

          it 'returns nil' do
            expect(subject.as_word).to be_empty
          end
        end

        context 'for one letter' do
          subject { Node.new 'a' }

          it 'returns the expected one letter word' do
            expect(subject.as_word).to eq 'a'
          end
        end

        context 'for a small word' do
          subject { Node.new 'all' }

          it 'returns the expected small word' do
            expect(subject[:l][:l].as_word).to eq 'all'
          end

          it 'raises an error for a non terminal node' do
            expect { subject[:l].as_word }.to raise_error InvalidOperation
          end
        end

        context 'for a long word' do
          subject { Node.new 'beautiful' }

          it 'returns the expected long word' do
            expect(subject[:e][:a][:u][:t][:i][:f][:u][:l].as_word).to eq 'beautiful'
          end
        end

        context 'for a node with nil letter' do
          subject { Node.new nil }
          it 'returns nil' do
            expect(subject.as_word).to be_empty
          end
        end
      end

      describe '#compressed?' do
        let(:root) { double 'Root' }
        subject { Node.new '', root }

        context 'parent is compressed' do
          before do
            root.stub(:compressed?).and_return true
          end

          it 'returns true' do
            expect(subject).to be_compressed
          end
        end

        context 'parent is not compressed' do
          before do
            root.stub(:compressed?).and_return false
          end

          it 'returns false' do
            expect(subject).to_not be_compressed
          end
        end
      end
    end
  end
end
