# frozen_string_literal: true

shared_examples_for 'a trie data structure' do
  it 'contains all the words previously provided' do
    words.each { |word| expect(trie).to include word }
  end

  it 'returns true for #word? for all words previously provided' do
    words.each { |word| expect(trie.word? word).to be true }
  end

  it 'matches the full word for all words in file' do
    words.each { |word| expect(trie.match? word).to be true }
  end

  it 'matches the start of all the words in file' do
    words.each { |word| expect(trie.match? word[0..-2]).to be true }
  end

  it 'returns true for #partial_word? with full word for all words in file' do
    words.each { |word| expect(trie.partial_word? word).to be true }
  end

  it 'returns true for #partial_word? with the start of all words in file' do
    words.each { |word| expect(trie.partial_word? word[0..-2]).to be true }
  end

  it 'extracts words within larger strings' do
    words.each do |word|
      phrase = "x#{word}y"
      expect(trie.words_within phrase).to include word
    end
  end

  it 'identifies words within larger strings' do
    words.each do |word|
      phrase = "x#{word}y"
      expect(trie.words_within? phrase).to be true
    end
  end

  it 'allows iterating over all the words' do
    expect(trie.to_a.sort).to eq words.sort
  end
end
