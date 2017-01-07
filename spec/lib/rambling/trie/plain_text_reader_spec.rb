require 'spec_helper'

module Rambling
  module Trie
    describe PlainTextReader do
      describe '#each_word' do
        let(:filepath) { File.join(::SPEC_ROOT, 'assets', 'test_words.en_US.txt') }
        let(:words) { File.readlines(filepath).map &:chomp }

        it 'yields every word yielded by the file' do
          yielded_words = []
          subject.each_word(filepath) { |word| yielded_words << word }
          expect(yielded_words).to eq words
        end
      end
    end
  end
end
