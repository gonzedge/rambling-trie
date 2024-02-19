# frozen_string_literal: true

require 'spec_helper'

module Rambling
  module Trie
    describe Enumerable do
      let(:node) { Rambling::Trie::Nodes::Raw.new }
      let(:words) { %w(add some words and another word) }

      before { add_words node, words }

      describe '#each' do
        it 'returns an enumerator when no block is given' do
          expect(node.each).to be_an Enumerator
        end

        it 'iterates through all words contained in the trie' do
          expect(node.each.to_a).to match_array words
        end

        it 'has the same word count as the trie' do
          expect(node.count).to eq words.count
        end

        it 'yields every word contained in the trie' do
          node.each { |word| expect(words).to include word }
        end

        it 'returns the enumerable when a block is given' do
          expect(node.each { |word| print word }).to eq node
        end
      end

      describe '#size' do
        it 'delegates to #count' do
          expect(node.size).to eq words.size
        end
      end

      it 'includes #all? from the core Enumerable module' do
        expect(node.all? { |word| words.include? word }).to be true
      end

      it 'includes #any? from the core Enumerable module' do
        expect(node.any? { |word| word.start_with? 's' }).to be true
      end

      it 'includes #to_a from the core Enumerable module' do
        expect(node.to_a).to match_array words
      end
    end
  end
end
