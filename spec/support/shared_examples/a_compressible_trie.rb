# frozen_string_literal: true

shared_examples_for 'a compressible trie' do
  context 'with an uncompressed trie' do
    it_behaves_like 'a trie data structure'

    it 'does not alter the input' do
      word = 'string'
      add_word trie, word

      expect(word).to eq 'string'
    end

    it 'is marked as not compressed' do
      expect(trie).not_to be_compressed
    end
  end

  context 'with an compressed trie' do
    let!(:original_root) { trie.root }
    let!(:original_keys) { original_root.children_tree.keys }
    let!(:original_values) { original_root.children_tree.values }

    before do
      trie.compress!
    end

    it_behaves_like 'a trie data structure'

    it 'is marked as compressed' do
      expect(trie).to be_compressed
    end

    it 'leaves the original root keys intact' do
      expect(original_root.children_tree.keys).to eq original_keys
    end

    it 'leaves the original trie keys intact' do
      expect(trie.children_tree.keys).to eq original_keys
    end

    it 'leaves the original trie values intact' do
      expect(trie.children_tree.values).not_to eq original_values
    end
  end
end
