require 'spec_helper'

describe Rambling::Trie::Serializers::Marshal do
  let(:serializer) { Rambling::Trie::Serializers::Marshal.new }

  let(:words) { %w(a few words to validate that load and dump are working) }
  let(:trie) { Rambling::Trie.create { |t| words.each { |w| t << w } } }

  it_behaves_like 'a serializer' do
    let(:filepath) { File.join ::SPEC_ROOT, 'tmp', 'trie-root.marshal' }
    let(:content) { trie.root }
    let(:formatted_content) { Marshal.dump content }
  end
end
