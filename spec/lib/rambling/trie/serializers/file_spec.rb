require 'spec_helper'

describe Rambling::Trie::Serializers::File do
  let(:serializer) { Rambling::Trie::Serializers::File.new }

  it_behaves_like 'a serializer' do
    let(:filepath) { File.join ::SPEC_ROOT, 'tmp', 'trie-root.file' }
    let(:content) { 'a few words to validate that load and dump are working' }
    let(:formatted_content) { content }
  end
end
