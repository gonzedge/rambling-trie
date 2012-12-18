require 'spec_helper'

module Rambling
  describe Trie do
    describe '.create' do
      let(:root) { double Trie::Root }

      before { Trie::Root.stub(:new).and_yield(root).and_return(root) }

      it 'returns a new instance of the trie root node' do
        expect(Trie.create).to eq root
      end

      context 'with a block' do
        it 'yields the instantiated root' do
          yielded_trie = nil
          Trie.create { |trie| yielded_trie = trie }
          expect(yielded_trie).to eq root
        end
      end

      context 'with a filename' do
        let(:filename) { File.join(::SPEC_ROOT, 'assets', 'test_words.txt') }
        let(:words) { File.readlines(filename).map &:chomp }

        it 'loads every word' do
          words.each { |word| root.should_receive(:<<).with(word) }

          Trie.create filename
        end
      end
    end
  end
end
