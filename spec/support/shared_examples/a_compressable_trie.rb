shared_examples_for 'a compressable trie' do
  context 'and the trie is not compressed' do
    it_behaves_like 'a trie data structure'

    it 'does not alter the input' do
      word = 'string'
      trie.add word

      expect(word).to eq 'string'
    end

    it 'is marked as not compressed' do
      expect(trie).not_to be_compressed
    end
  end

  context 'and the trie is compressed' do
    before { trie.compress! }

    it_behaves_like 'a trie data structure'

    it 'is marked as compressed' do
      expect(trie).to be_compressed
    end
  end
end
