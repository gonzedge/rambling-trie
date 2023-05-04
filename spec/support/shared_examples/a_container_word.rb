# frozen_string_literal: true

shared_examples_for 'a matching container#word' do
  %w(hello high).each do |word|
    it 'matches the whole word' do
      expect(container.word? word).to be true
    end
  end
end

shared_examples_for 'a non-matching container#word' do
  %w(halt al).each do |word|
    it 'does not match the whole word' do
      expect(container.word? word).to be false
    end
  end
end

shared_examples_for 'a propagating node' do
  [
    [true, 'Rambling::Trie::Nodes::Compressed'],
    [false, 'Rambling::Trie::Nodes::Raw'],
  ].each do |test_params|
    compressed_value, instance_double_class = test_params

    context "when root has compressed=#{compressed_value}" do
      let(:root) do
        instance_double(
          instance_double_class,
          :root,
          compressed?: compressed_value,
          word?: nil,
          partial_word?: nil,
        )
      end

      it 'calls the root with the word characters' do
        container.public_send method, 'words'
        expect(root).to have_received(method).with %w(w o r d s)
      end
    end
  end

end
