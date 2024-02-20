# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Stringifyable do
  describe '#as_word' do
    let(:parent) { Rambling::Trie::Nodes::Raw.new }
    let(:node) { Rambling::Trie::Nodes::Raw.new nil, parent }

    context 'with an empty node' do
      before { add_word node, '' }

      it 'returns nil' do
        expect(node.as_word).to be_empty
      end

      context 'with no parent' do
        let(:parent) { nil }
        it 'returns nil' do
          expect(node.as_word).to be_empty
        end
      end
    end

    context 'with one letter' do
      before do
        node.letter = :a
        add_word node, ''
      end

      it 'returns the expected one letter word' do
        expect(node.as_word).to eq 'a'
      end
    end

    context 'with a small word' do
      before do
        node.letter = :a
        add_word node, 'll'
      end

      it 'returns the expected small word' do
        expect(node[:l][:l].as_word).to eq 'all'
      end

      it 'raises an error for a non terminal node' do
        expect { node[:l].as_word }
          .to raise_error Rambling::Trie::InvalidOperation
      end
    end

    context 'with a long word' do
      before do
        node.letter = :b
        add_word node, 'eautiful'
      end

      it 'returns the expected long word' do
        expect(node[:e][:a][:u][:t][:i][:f][:u][:l].as_word).to eq 'beautiful'
      end
    end

    context 'with a node with nil letter' do
      let(:node) { Rambling::Trie::Nodes::Raw.new nil }

      it 'returns nil' do
        expect(node.as_word).to be_empty
      end
    end

    context 'with a compressed node' do
      let(:compressor) { Rambling::Trie::Compressor.new }
      let(:compressed_node) { compressor.compress node }

      before do
        node.letter = :a
        add_words node, %w(m dd)
      end

      [
        [:m, 'am'],
        [:d, 'add'],
      ].each do |test_params|
        key, expected = test_params

        it "returns the words for terminal nodes (#{key} => #{expected})" do
          expect(compressed_node[key].as_word).to eq expected
        end
      end

      it 'raises an error for non terminal nodes' do
        expect { compressed_node.as_word }
          .to raise_error Rambling::Trie::InvalidOperation
      end
    end
  end
end
