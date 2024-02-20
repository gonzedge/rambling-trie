# frozen_string_literal: true

shared_examples_for 'a serializer' do
  subject(:serializer) { described_class.new }

  let(:trie) { Rambling::Trie.create }
  let(:tmp_path) { File.join SPEC_ROOT, 'tmp' }
  let(:filepath) { File.join tmp_path, "trie-root.#{file_format}" }
  let(:content) { trie.root }

  before do
    trie.concat %w(a few words to validate that load and dump are working)
    FileUtils.rm_f filepath
  end

  describe '#dump' do
    [true, false].each do |compress_value|
      context "with compressed=#{compress_value} trie" do
        let(:formatted_content) { format_content.call content }

        before { trie.compress! if compress_value }

        it 'returns the size in bytes of the file dumped' do
          total_bytes = serializer.dump content, filepath
          expect(total_bytes).to be_within(20).of formatted_content.size
        end

        it 'creates the file with the provided path' do
          serializer.dump content, filepath
          expect(File.exist? filepath).to be true
        end

        it 'converts the contents to the appropriate format' do
          serializer.dump content, filepath
          expect(File.size filepath).to be_within(20).of formatted_content.size
        end
      end
    end
  end

  describe '#load' do
    [true, false].each do |compress_value|
      context "with compressed=#{compress_value} trie" do
        before do
          trie.compress! if compress_value
          serializer.dump content, filepath
        end

        it 'loads the dumped object back into memory' do
          expect(serializer.load filepath).to eq content
        end

        it "loads a compressed=#{compress_value} object" do
          loaded = serializer.load filepath
          expect(loaded.compressed?).to be compress_value unless :file == file_format
        end
      end
    end
  end
end
