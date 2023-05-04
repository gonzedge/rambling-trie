# frozen_string_literal: true

shared_examples_for 'a matching container#partial_word' do
  %w(h he hell hello hi hig high).each do |prefix|
    it 'matches part of the word' do
      expect(container.partial_word? prefix).to be true
    end
  end
end

shared_examples_for 'a non-matching container#partial_word' do
  it 'does not match any part of the word' do
    %w(ha hal al).each do |word|
      expect(container.partial_word? word).to be false
    end
  end
end
