# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::Marshal do
  it_behaves_like 'a serializer' do
    let(:file_format) { :marshal }
    let(:format_content) { Marshal.method(:dump) }
  end

  describe 'marshal-only behavior' do
    describe '#load' do
      subject(:serializer) { described_class.new }

      let(:trie) { Rambling::Trie.create }
      let(:tmp_path) { File.join SPEC_ROOT, 'tmp' }
      let(:filepath) { File.join tmp_path, 'trie-root.marshal' }

      before do
        trie.concat %w(hello world)
        serializer.dump trie.root, filepath
      end

      it 'emits a security warning to stderr' do
        expect { serializer.load filepath }
          .to output(%r{Marshal\.load.*untrusted}i).to_stderr
      end
    end
  end
end
