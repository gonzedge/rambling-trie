require 'spec_helper'

describe Rambling::Trie do
  describe '.create' do
    let(:container) { double :container }

    before do
      allow(Rambling::Trie::Container).to receive(:new)
        .and_yield(container)
        .and_return container
    end

    it 'returns a new instance of the trie container' do
      expect(Rambling::Trie.create).to eq container
    end

    context 'with a block' do
      it 'yields the new container' do
        yielded_trie = nil
        Rambling::Trie.create { |trie| yielded_trie = trie }
        expect(yielded_trie).to eq container
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
        allow(container).to receive :<<
      end

      it 'loads every word' do
        Rambling::Trie.create filepath, reader

        words.each do |word|
          expect(container).to have_received(:<<).with(word)
        end
      end
    end

    context 'without any reader' do
      let(:filepath) { 'test_words.txt' }
      let(:reader) { double :reader, each_word: nil }

      before do
        allow(Rambling::Trie::PlainTextReader).to receive(:new)
          .and_return reader
      end

      it 'defaults to the PlainTextReader' do
        Rambling::Trie.create filepath, nil

        expect(reader).to have_received(:each_word).with filepath
      end
    end
  end
end
