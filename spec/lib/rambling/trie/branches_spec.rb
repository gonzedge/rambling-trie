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

          it 'returns the added node' do
            expect(node.add_branch('a').letter).to eq :a
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

      describe '#<<' do
        let(:node) { Node.new }
        let(:word) { 'word' }

        it 'delegates to #add_branch' do
          expect((node << 'a').letter).to eq :a
        end
      end
    end
  end
end
