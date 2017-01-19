shared_examples_for 'a serializable trie' do
  context 'and the trie is not compressed' do
    before do
      Rambling::Trie.dump trie_to_serialize, trie_filepath, serializer
    end

    it_behaves_like 'a compressable trie' do
      let(:trie) { loaded_trie }
    end
  end

  context 'and the trie is compressed' do
    let(:trie) { loaded_trie }

    before do
      FileUtils.rm_f trie_filepath
      Rambling::Trie.dump trie_to_serialize.compress!, trie_filepath, serializer
    end

    it_behaves_like 'a trie data structure'

    it 'is marked as compressed' do
      expect(trie).to be_compressed
    end
  end
end
