shared_examples_for 'a serializer' do
  before do
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
