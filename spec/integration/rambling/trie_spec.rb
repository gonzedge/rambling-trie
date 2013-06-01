require 'spec_helper'

describe Rambling::Trie do
  describe 'when a filepath is provided' do
    let(:filepath) { File.join ::SPEC_ROOT, 'assets', 'test_words.txt' }
    let(:words) { File.readlines(filepath).map &:chomp }
    subject { Rambling::Trie.create filepath }

    it 'contains all the words from the file' do
      words.each { |word| expect(subject).to include word }
    end

    describe 'and the trie is compressed' do
      it 'still contains all the words from the file' do
        subject.compress!
        words.each { |word| expect(subject).to include word }
      end
    end
  end
end
