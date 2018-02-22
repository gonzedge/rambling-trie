# frozen_string_literal: true

shared_examples_for 'a serializable trie' do
  let(:tmp_path) { File.join ::SPEC_ROOT, 'tmp' }
  let(:filepath) { File.join tmp_path, "trie-root.#{format}" }

  context 'and the trie is not compressed' do
    before do
      Rambling::Trie.dump trie_to_serialize, filepath
    end

    it_behaves_like 'a compressible trie' do
      let(:trie) { Rambling::Trie.load filepath }
    end
  end

  context 'and the trie is compressed' do
    let(:trie) { Rambling::Trie.load filepath }

    before do
      Rambling::Trie.dump trie_to_serialize.compress!, filepath
    end

    it_behaves_like 'a trie data structure'

    it 'is marked as compressed' do
      expect(trie).to be_compressed
    end
  end
end
