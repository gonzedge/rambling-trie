# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::File do
  it_behaves_like 'a serializer' do
    let(:serializer) { Rambling::Trie::Serializers::File.new }
    let(:format) { :file }

    let(:content) { trie.to_a.join ' ' }
    let(:formatted_content) { content }
  end
end
