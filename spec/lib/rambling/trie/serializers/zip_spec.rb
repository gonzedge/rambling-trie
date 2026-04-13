# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::Zip do
  {
    yaml: YAML.method(:dump),
    yml: YAML.method(:dump),
    marshal: Marshal.method(:dump),
    file: Marshal.method(:dump),
  }.each do |file_format, dump_method|
    context "with '.#{file_format}'" do
      it_behaves_like 'a serializer' do
        let(:properties) { Rambling::Trie::Configuration::Properties.new }
        let(:serializer) { described_class.new properties }
        let(:file_format) { :zip }

        let(:filepath) { File.join tmp_path, "trie-root.#{file_format}.zip" }
        let(:format_content) { ->(content) { zip dump_method.call content } }
        let(:filename) { File.basename(filepath).gsub %r{\.zip}, '' }

        before { properties.tmp_path = tmp_path }
      end
    end
  end

  describe 'zip-only behavior' do
    let(:properties) { Rambling::Trie::Configuration::Properties.new }
    let(:serializer) { described_class.new properties }
    let(:tmp_path) { File.join SPEC_ROOT, 'tmp' }
    let(:trie) { Rambling::Trie.create }
    let(:zip_path) { File.join tmp_path, 'cleanup_test.marshal.zip' }
    let(:cleanup_test_glob) { Dir.glob File.join(tmp_path, '*cleanup_test*') }

    before do
      properties.tmp_path = tmp_path
      trie.concat %w(test cleanup words)
      FileUtils.rm_f cleanup_test_glob
    end

    after do
      FileUtils.rm_f zip_path
      FileUtils.rm_f cleanup_test_glob
    end

    describe '#dump' do
      it 'removes the tmp file' do
        serializer.dump trie.root, zip_path

        leftover_files = Dir.glob(File.join(tmp_path, '*-cleanup_test.marshal'))
        expect(leftover_files).to be_empty
      end
    end

    describe '#load' do
      it 'removes the tmp file after #load' do
        serializer.dump trie.root, zip_path
        serializer.load zip_path

        leftover_files = Dir.glob(File.join(tmp_path, '*-cleanup_test.marshal'))
        expect(leftover_files).to be_empty
      end
    end
  end

  def zip content
    cursor = Zip::OutputStream.write_buffer do |io|
      io.put_next_entry filename
      io.write content
    end

    cursor.rewind
    cursor.read
  end
end
