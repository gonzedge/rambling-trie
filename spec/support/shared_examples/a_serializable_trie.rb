# frozen_string_literal: true

shared_examples_for 'a serializable trie' do
  let(:tmp_path) { File.join SPEC_ROOT, 'tmp' }
  let(:filepath) { File.join tmp_path, "trie-root.#{file_format}" }

  context 'with an uncompressed trie' do
    before { Rambling::Trie.dump trie_to_serialize, filepath }

    it_behaves_like 'a compressible trie' do
      let(:trie) { Rambling::Trie.load filepath }
    end
  end

  context 'with an compressed trie' do
    let(:trie) { Rambling::Trie.load filepath }

    before { Rambling::Trie.dump trie_to_serialize.compress!, filepath }

    it_behaves_like 'a trie data structure'

    it 'is marked as compressed' do
      expect(trie).to be_compressed
    end
  end
end
