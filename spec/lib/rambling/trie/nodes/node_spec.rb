# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Nodes::Node do
  it_behaves_like 'a trie node' do
    let(:node) { described_class.new }
  end
end
