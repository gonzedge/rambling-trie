require 'spec_helper'

module Rambling
  describe Trie do
    describe '.create' do
      let(:root) { double :root }

      before { allow(Trie::Root).to receive(:new).and_yield(root).and_return root }

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

      context 'with a filepath' do
        let(:filepath) { 'test_words.txt' }
        let(:reader) { double :reader }
        let(:words) { %w(a couple of test words over here) }

        before do
          receive_and_yield = receive(:each_word)
          words.inject(receive_and_yield) { |yielder, word| yielder.and_yield word }
          allow(reader).to receive_and_yield
        end

        it 'loads every word' do
          words.each { |word| expect(root).to receive(:<<).with(word) }

          Trie.create filepath, reader
        end
      end
    end
  end
end
