require 'spec_helper'

describe Rambling::Trie::Nodes::Node do
  it_behaves_like 'a trie node' do
    let(:node) { Rambling::Trie::Nodes::Node.new }
  end
end
