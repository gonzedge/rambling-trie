# frozen_string_literal: true

shared_examples_for 'a compressible trie' do
  context 'with an uncompressed trie' do
    it_behaves_like 'a trie data structure'

    it 'does not alter the input word' do
      word = 'string'
      add_word trie, word

      expect(word).to eq 'string'
    end

    it 'does not alert the input' do
      value = 'string'
      add_word trie, 'word', value

      expect(value).to eq 'string'
    end

    it 'is marked as not compressed' do
      expect(trie).not_to be_compressed
    end
  end

  context 'with a compressed trie' do
    let!(:original_root) { trie.root }
    let!(:original_keys) { original_root.children_tree.keys }
    let!(:original_values) { original_root.children_tree.values }

    before { trie.compress! }

    it_behaves_like 'a trie data structure'

    it 'is marked as compressed' do
      expect(trie).to be_compressed
    end

    it 'leaves the original root keys intact' do
      expect(original_root.children_tree.keys).to eq original_keys
    end

    it 'leaves the original trie children tree keys intact' do
      expect(trie.children_tree.keys).to eq original_keys
    end

    it 'changes the original trie children tree values' do
      expect(trie.children_tree.values).not_to eq original_values
    end
  end
end
