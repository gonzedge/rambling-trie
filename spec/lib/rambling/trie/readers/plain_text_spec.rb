# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Readers::PlainText do
  subject(:reader) { described_class.new }

  describe '#each_word' do
    let(:filepath) { File.join(::SPEC_ROOT, 'assets', 'test_words.en_US.txt') }
    let(:words) { File.readlines(filepath).map(&:chomp) }

    it 'yields every word yielded by the file' do
      yielded = []
      reader.each_word(filepath) { |word| yielded << word }
      expect(yielded).to eq words
    end
  end
end
