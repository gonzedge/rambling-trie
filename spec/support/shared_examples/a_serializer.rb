# frozen_string_literal: true

shared_examples_for 'a serializer' do
  let(:trie) { Rambling::Trie.create }
  let(:tmp_path) { File.join ::SPEC_ROOT, 'tmp' }
  let(:filepath) { File.join tmp_path, "trie-root.#{format}" }
  let(:content) { trie.root }

  before do
    trie.concat %w(a few words to validate that load and dump are working)
    FileUtils.rm_f filepath
  end

  describe '#dump' do
    before do
      serializer.dump content, filepath
    end

    it 'creates the file with the provided path' do
      expect(File.exist? filepath).to be true
    end

    it 'converts the contents to the appropriate format' do
      expect(File.read(filepath).size).to eq formatted_content.size
    end
  end

  describe '#load' do
    before do
      serializer.dump content, filepath
    end

    it 'loads the dumped object back into memory' do
      expect(serializer.load filepath).to eq content
    end
  end
end
