# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::File do
  it_behaves_like 'a serializer' do
    let(:format) { :file }
    let(:content) { trie.to_a.join ' ' }
    let(:format_content) { ->(content) { content } }
  end
end
