require 'spec_helper'

describe Rambling::Trie::Serializers::Marshal do
  let(:serializer) { Rambling::Trie::Serializers::Marshal.new }

  let(:words) { %w(a few words to validate that load and dump are working) }
  let(:trie) { Rambling::Trie.create { |t| words.each { |w| t << w } } }
  let(:filepath) { File.join ::SPEC_ROOT, 'tmp', 'trie-root.marshal' }

  it 'loads the object as it was dumped' do
    serializer.dump trie, filepath
    expect(serializer.load filepath).to eq trie
  end
end
