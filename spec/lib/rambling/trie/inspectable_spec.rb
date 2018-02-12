require 'spec_helper'

describe Rambling::Trie::Inspectable do
  let(:root) { Rambling::Trie::RawNode.new }

  before do
    [
      %i(o n l y),
      %i(t h r e e),
      %i(w o r d s)
    ].each { |word| root.add word }
  end

  describe '#inspect' do
    let(:node) { root[:o] }
    let(:terminal_node) { root[:o][:n][:l][:y] }

    it 'returns a pretty printed version of the node' do
      expect(root.inspect).to eq "#<Rambling::Trie::RawNode letter: nil, terminal: nil, children: [:o, :t, :w]>"
      expect(node.inspect).to eq "#<Rambling::Trie::RawNode letter: :o, terminal: nil, children: [:n]>"
      expect(terminal_node.inspect).to eq "#<Rambling::Trie::RawNode letter: :y, terminal: true, children: []>"
    end

    context 'for a compressed node' do
      let(:compressor) { Rambling::Trie::Compressor.new }
      let(:compressed_root) { compressor.compress root }
      let(:compressed_node) { compressed_root[:only] }

      it 'returns a pretty printed version of the compressed node' do
        expect(compressed_root.inspect).to eq "#<Rambling::Trie::CompressedNode letter: nil, terminal: nil, children: [:only, :three, :words]>"
        expect(compressed_node.inspect).to eq "#<Rambling::Trie::CompressedNode letter: :only, terminal: true, children: []>"
      end
    end
  end
end
