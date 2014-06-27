require 'spec_helper'

module Rambling
  module Trie
    describe Branches do
      describe '#add' do
        context 'new word for existing branch' do
          let(:node) { Node.new 'back' }

          before do
            node.add 'a'
          end

          it 'does not increment the child count' do
            expect(node.children.size).to eq 1
          end

          it 'marks it as terminal' do
            expect(node[:a]).to be_terminal
          end

          it 'returns the added node' do
            expect(node.add('a').letter).to eq :a
          end
        end

        context 'old word for existing branch' do
          let(:node) { Node.new 'back' }

          before do
            node.add 'ack'
          end

          it 'does not increment any child count' do
            expect(node.children.size).to eq 1
            expect(node[:a].children.size).to eq 1
            expect(node[:a][:c].children.size).to eq 1
            expect(node[:a][:c][:k].children.size).to eq 0
          end
        end
      end

      describe '#<<' do
        let(:node) { Node.new }

        it 'delegates to #add' do
          expect((node << 'a').letter).to eq :a
        end
      end
    end
  end
end
