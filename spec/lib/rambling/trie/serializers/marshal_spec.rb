require 'spec_helper'

describe Rambling::Trie::Serializers::Marshal do
  it_behaves_like 'a serializer' do
    let(:serializer) { Rambling::Trie::Serializers::Marshal.new }
    let(:format) { :marshal }

    let(:formatted_content) { Marshal.dump content }
  end
end
