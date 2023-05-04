# frozen_string_literal: true

shared_examples_for 'a matching container#words_within' do
  [
    ['word', %w(word)],
    ['wordxyz', %w(word)],
  ].each do |test_params|
    phrase, expected = test_params

    it "returns an array with the word found in the phrase '#{phrase}'" do
      expect(container.words_within phrase).to match_array expected
    end
  end
end

shared_examples_for 'a non-matching container#words_within' do
  it 'returns an array with all words found in the phrase' do
    expect(container.words_within 'xyzword otherzxyone')
      .to match_array %w(word other one)
  end
end

shared_examples_for 'a matching container#words_within?' do
    context 'when phrase does not contain any words' do
      it 'returns false' do
        expect(container.words_within? 'xyz').to be false
      end
    end

    context 'when phrase contains any word' do
      ['xyz words', 'xyzone word'].each do |phrase|
        it "returns true for '#{phrase}'" do
          expect(container.words_within? phrase).to be true
        end
      end
    end
end

shared_examples_for 'a non-matching container#words_within?' do
  it 'returns an array with all words found in the phrase' do
    expect(container.words_within 'xyzword otherzxyone')
      .to match_array %w(word other one)
  end
end
