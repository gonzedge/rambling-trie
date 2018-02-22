# frozen_string_literal: true

require 'spec_helper'

module Rambling
  module Trie
    describe Enumerable do
      let(:node) { Rambling::Trie::Nodes::Raw.new }
      let(:words) { %w(add some words and another word) }

      before do
        add_words node, words
      end

      describe '#each' do
        it 'returns an enumerator' do
          expect(node.each).to be_a Enumerator
        end

        it 'includes every word contained in the trie' do
          node.each do |word|
            expect(words).to include word
          end

          expect(node.count).to eq words.count
        end
      end

      describe '#size' do
        it 'delegates to #count' do
          expect(node.size).to eq words.size
        end
      end

      it 'includes the core Enumerable module' do
        expect(node.all? { |word| words.include? word }).to be true
        expect(node.any? { |word| word.start_with? 's' }).to be true
        expect(node.to_a).to match_array words
      end
    end
  end
end
