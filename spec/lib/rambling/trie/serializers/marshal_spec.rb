# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::Marshal do
  it_behaves_like 'a serializer' do
    let(:serializer) { described_class.new }
    let(:format) { :marshal }

    let(:formatted_content) { Marshal.dump content }
  end
end
