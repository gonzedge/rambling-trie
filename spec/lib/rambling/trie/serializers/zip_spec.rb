require 'spec_helper'

describe Rambling::Trie::Serializers::Zip do
  let(:properties) { Rambling::Trie::Configuration::Properties.new }
  let(:serializer) { Rambling::Trie::Serializers::Zip.new properties }

  let(:words) { %w(a few words to validate that load and dump are working) }
  let(:trie) { Rambling::Trie.create { |t| words.each { |w| t << w } } }
  let(:tmp_path) { File.join ::SPEC_ROOT, 'tmp' }

  before do
    properties.tmp_path = tmp_path
  end

  it_behaves_like 'a serializer' do
    let(:filename) { 'trie-root.marshal' }
    let(:filepath) { File.join tmp_path, "#{filename}.zip" }
    let(:content) { trie.root }
    let(:formatted_content) { zip Marshal.dump content }
  end

  def zip content
    io = Zip::OutputStream.write_buffer do |io|
      io.put_next_entry filename
      io.write content
    end
    io.rewind
    io.sysread
  end
end
