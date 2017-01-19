require 'spec_helper'

describe Rambling::Trie::Serializers::Yaml do
  let(:serializer) { Rambling::Trie::Serializers::Yaml.new }

  let(:words) { %w(a few words to validate that load and dump are working) }
  let(:trie) { Rambling::Trie.create { |t| words.each { |w| t << w } } }

  it_behaves_like 'a serializer' do
    let(:filepath) { File.join ::SPEC_ROOT, 'tmp', 'trie-root.yml' }
    let(:content) { trie.root }
    let(:formatted_content) { YAML.dump content }
  end
end
