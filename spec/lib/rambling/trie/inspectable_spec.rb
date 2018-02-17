require 'spec_helper'

describe Rambling::Trie::Inspectable do
  let(:node) { Rambling::Trie::Nodes::Raw.new }

  before do
    add_words node, %w(only three words)
  end

  describe '#inspect' do
    let(:child) { node[:o] }
    let(:terminal_node) { node[:o][:n][:l][:y] }

    it 'returns a pretty printed version of the node' do
      expect(node.inspect).to eq "#<Rambling::Trie::Nodes::Raw letter: nil, terminal: nil, children: [:o, :t, :w]>"
      expect(child.inspect).to eq "#<Rambling::Trie::Nodes::Raw letter: :o, terminal: nil, children: [:n]>"
      expect(terminal_node.inspect).to eq "#<Rambling::Trie::Nodes::Raw letter: :y, terminal: true, children: []>"
    end

    context 'for a compressed node' do
      let(:compressor) { Rambling::Trie::Compressor.new }
      let(:compressed_node) { compressor.compress node }
      let(:compressed_child) { compressed_node[:only] }

      it 'returns a pretty printed version of the compressed node' do
        expect(compressed_node.inspect).to eq "#<Rambling::Trie::Nodes::Compressed letter: nil, terminal: nil, children: [:only, :three, :words]>"
        expect(compressed_child.inspect).to eq "#<Rambling::Trie::Nodes::Compressed letter: :only, terminal: true, children: []>"
      end
    end
  end
end
