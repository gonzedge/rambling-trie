require 'spec_helper'

module Rambling
  module Trie
    describe Branches do
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

      describe '#<<' do
        let(:root) { Root.new }
        let(:word) { 'word' }

        it 'delegates to #add_branch_from' do
          [true, false].each do |value|
            root.stub(:add_branch_from).with(word).and_return value
            root << word
          end
        end
      end
    end
  end
end
