require 'spec_helper'

describe Rambling::Trie::Serializers::File do
  let(:serializer) { Rambling::Trie::Serializers::File.new }

  let(:content) { 'a few words to validate that load and dump are working' }
  let(:filepath) { File.join ::SPEC_ROOT, 'tmp', 'trie-root.file' }

  it 'loads the object as it was dumped' do
    serializer.dump content, filepath
    expect(serializer.load filepath).to eq content
  end
end
