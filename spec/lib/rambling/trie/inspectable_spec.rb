# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Inspectable do
  let(:node) { Rambling::Trie::Nodes::Raw.new }

  before do
    add_words node, %w(only three words)
  end

  describe '#inspect' do
    let(:child) { node[:o] }
    let(:terminal_node) { node[:o][:n][:l][:y] }

    it 'returns a pretty printed version of the parent node' do
      expect(node.inspect).to eq one_line <<~RAW
        #<Rambling::Trie::Nodes::Raw letter: nil,
        terminal: nil,
        children: [:o, :t, :w]>
      RAW
    end

    it 'returns a pretty printed version of the child node' do
      expect(child.inspect).to eq one_line <<~CHILD
        #<Rambling::Trie::Nodes::Raw letter: :o,
        terminal: nil,
        children: [:n]>
      CHILD
    end

    it 'returns a pretty printed version of the terminal node' do
      expect(terminal_node.inspect).to eq one_line <<~TERMINAL
        #<Rambling::Trie::Nodes::Raw letter: :y,
        terminal: true,
        children: []>
      TERMINAL
    end

    context 'with a compressed node' do
      let(:compressor) { Rambling::Trie::Compressors::WithMergingStrategy.new }
      let(:compressed) { compressor.compress node }
      let(:compressed_child) { compressed[:o] }

      it 'returns a pretty printed version of the compressed parent node' do
        expect(compressed.inspect).to eq one_line <<~COMPRESSED
          #<Rambling::Trie::Nodes::Compressed letter: nil,
          terminal: nil,
          children: [:o, :t, :w]>
        COMPRESSED
      end

      it 'returns a pretty printed version of the compressed child node' do
        expect(compressed_child.inspect).to eq one_line <<~CHILD
          #<Rambling::Trie::Nodes::Compressed letter: :only,
          terminal: true,
          children: []>
        CHILD
      end
    end
  end
end
