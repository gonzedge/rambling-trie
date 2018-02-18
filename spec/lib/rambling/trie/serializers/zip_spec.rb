require 'spec_helper'

describe Rambling::Trie::Serializers::Zip do
  it_behaves_like 'a serializer' do
    let(:properties) { Rambling::Trie::Configuration::Properties.new }
    let(:serializer) { Rambling::Trie::Serializers::Zip.new properties }
    let(:format) { 'marshal.zip' }

    before do
      properties.tmp_path = tmp_path
    end

    let(:filename) { File.basename(filepath).gsub /\.zip/, ''}
    let(:formatted_content) { zip Marshal.dump content }

    def zip content
      io = Zip::OutputStream.write_buffer do |io|
        io.put_next_entry filename
        io.write content
      end

      io.rewind
      io.read
    end
  end
end
