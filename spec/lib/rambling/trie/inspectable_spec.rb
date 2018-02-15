require 'spec_helper'

describe Rambling::Trie::Inspectable do
  let(:root) { Rambling::Trie::Nodes::Raw.new }

  before do
    %w(only three words).each do |word|
      root.add word.chars.reverse.map(&:to_sym)
    end
  end

  describe '#inspect' do
    let(:node) { root[:o] }
    let(:terminal_node) { root[:o][:n][:l][:y] }

    it 'returns a pretty printed version of the node' do
      expect(root.inspect).to eq "#<Rambling::Trie::Nodes::Raw letter: nil, terminal: nil, children: [:o, :t, :w]>"
      expect(node.inspect).to eq "#<Rambling::Trie::Nodes::Raw letter: :o, terminal: nil, children: [:n]>"
      expect(terminal_node.inspect).to eq "#<Rambling::Trie::Nodes::Raw letter: :y, terminal: true, children: []>"
    end

    context 'for a compressed node' do
      let(:compressor) { Rambling::Trie::Compressor.new }
      let(:compressed_root) { compressor.compress root }
      let(:compressed_node) { compressed_root[:only] }

      it 'returns a pretty printed version of the compressed node' do
        expect(compressed_root.inspect).to eq "#<Rambling::Trie::Nodes::Compressed letter: nil, terminal: nil, children: [:only, :three, :words]>"
        expect(compressed_node.inspect).to eq "#<Rambling::Trie::Nodes::Compressed letter: :only, terminal: true, children: []>"
      end
    end
  end
end
