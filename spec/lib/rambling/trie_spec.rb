require 'spec_helper'

module Rambling
  describe Trie do
    describe '.create' do
      let(:root) { double 'Trie::Root' }

      before :each do
        Trie::Root.stub(:new).and_return root
      end

      it 'returns a new instance of the trie root node' do
        Trie.create.should == root
      end
    end

    describe '.new' do
      let(:root) { double 'Trie::Root' }

      before :each do
        Trie.should_receive(:create).and_return root
      end

      it 'returns the new trie root node instance' do
        Trie.new.should == root
      end

      it 'warns about deprecation' do
        Trie.should_receive(:warn).with '[DEPRECATION] `new` is deprecated. Please use `create` instead.'
        Trie.new
      end
    end
  end
end
