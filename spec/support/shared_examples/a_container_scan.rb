# frozen_string_literal: true

shared_examples_for 'a matching container#scan' do
  [
    ['hi', %w(hi high highlight histerical)],
    ['hig', %w(high highlight)],
  ].each do |test_params|
    prefix, expected = test_params

    it "returns an array with the words that match '#{prefix}'" do
      expect(container.scan prefix).to eq expected
    end
  end
end
