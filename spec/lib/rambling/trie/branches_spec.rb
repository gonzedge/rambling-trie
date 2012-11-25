require 'spec_helper'

module Rambling
  module Trie
    describe Branches do
      describe '#add_branch' do
        context 'new word for existing branch' do
          let(:node) { Node.new 'back' }

          before do
            node.add_branch 'a'
          end

          it 'does not increment the child count' do
            expect(node).to have(1).children
          end

          it 'marks it as terminal' do
            expect(node[:a]).to be_terminal
          end
        end

        context 'old word for existing branch' do
          let(:node) { Node.new 'back' }

          before do
            node.add_branch 'ack'
          end

          it 'does not increment any child count' do
            expect(node).to have(1).children
            expect(node[:a]).to have(1).children
            expect(node[:a][:c]).to have(1).children
            expect(node[:a][:c][:k]).to have(0).children
          end
        end
      end

      describe '#add_branch_from' do
        let(:root) { Root.new }
        let(:node) { double('node') }
        let(:word) { 'word' }

        before do
          root.stub(:warn)
          root.stub(:add_branch)
        end

        it 'warns about deprecation' do
          root.should_receive(:warn)
          root.add_branch_from word
        end

        it 'delegates to #add_branch' do
          root.should_receive(:add_branch).with(word).and_return node
          expect(root.add_branch_from word).to eq node
        end
      end

      describe '#<<' do
        let(:root) { Root.new }
        let(:word) { 'word' }

        it 'delegates to #add_branch' do
          [true, false].each do |value|
            root.should_receive(:add_branch).with(word).and_return value
            expect(root << word).to eq value
          end
        end
      end
    end
  end
end
