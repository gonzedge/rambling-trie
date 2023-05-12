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

  def zip content
    cursor = Zip::OutputStream.write_buffer do |io|
      io.put_next_entry filename
      io.write content
    end

    cursor.rewind
    cursor.read
  end
end
