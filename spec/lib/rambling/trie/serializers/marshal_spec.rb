# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::Marshal do
  it_behaves_like 'a serializer' do
    let(:file_format) { :marshal }
    let(:format_content) { Marshal.method(:dump) }
  end
end
