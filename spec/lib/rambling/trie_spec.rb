require 'spec_helper'

module Rambling
  describe Trie do
    describe '.create' do
      let(:root) { double 'Trie::Root' }

      before do
        Trie::Root.stub(:new).and_return root
      end

      it 'returns a new instance of the trie root node' do
        expect(Trie.create).to eq root
      end
    end
  end
end
