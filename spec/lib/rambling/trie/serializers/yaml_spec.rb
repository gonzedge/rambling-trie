# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::Yaml do
  it_behaves_like 'a serializer' do
    let(:file_format) { :yml }
    let(:format_content) { YAML.method(:dump) }
  end
end
