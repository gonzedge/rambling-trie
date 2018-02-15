require 'spec_helper'

module Rambling
  module Trie
    describe Enumerable do
      let(:root) { Rambling::Trie::Nodes::Raw.new }
      let(:words) { %w(add some words and another word) }

      before do
        words.each { |word| root.add word.chars.reverse.map(&:to_sym) }
      end

      describe '#each' do
        it 'returns an enumerator' do
          expect(root.each).to be_a Enumerator
        end

        it 'includes every word contained in the trie' do
          root.each { |word| expect(words).to include word }
          expect(root.count).to eq words.count
        end
      end

      describe '#size' do
        it 'delegates to #count' do
          expect(root.size).to eq words.size
        end
      end

      it 'includes the core Enumerable module' do
        expect(root.all? { |word| words.include? word }).to be true
        expect(root.any? { |word| word.start_with? 's' }).to be true
        expect(root.to_a).to match_array words
      end
    end
  end
end
