require 'spec_helper'

describe Rambling::Trie::Inspector do
  let(:root) { Rambling::Trie::Container.new }
  let(:node) { root[:o] }

  before do
    %w(only three words).each { |word| root.add word }
  end

  describe '#inspect' do
    it 'returns a pretty printed version of the node' do
      expect(root.inspect).to eq "#<Rambling::Trie::Container letter: nil, children: [:o, :t, :w]>"
      expect(node.inspect).to eq "#<Rambling::Trie::RawNode letter: :o, children: [:n]>"
    end
  end
end
