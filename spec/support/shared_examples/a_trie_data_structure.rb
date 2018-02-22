# frozen_string_literal: true

shared_examples_for 'a trie data structure' do
  it 'contains all the words previously provided' do
    words.each do |word|
      expect(trie).to include word
      expect(trie.word? word).to be true
    end
  end

  it 'matches the start of all the words from the file' do
    words.each do |word|
      expect(trie.match? word).to be true
      expect(trie.match? word[0..-2]).to be true
      expect(trie.partial_word? word).to be true
      expect(trie.partial_word? word[0..-2]).to be true
    end
  end

  it 'identifies words within larger strings' do
    words.each do |word|
      phrase = "x#{word}y"
      expect(trie.words_within phrase).to include word
      expect(trie.words_within? phrase).to be true
    end
  end

  it 'allows iterating over all the words' do
    expect(trie.to_a.sort).to eq words.sort
  end
end
