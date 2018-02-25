# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Compressor do
  let(:compressor) { Rambling::Trie::Compressor.new }

  describe '#compress' do
    let(:node) { Rambling::Trie::Nodes::Raw.new }

    it 'compresses the node' do
      add_words node, %w(a few words hello hell)
      compressed = compressor.compress node

      expect(compressed.children_tree.keys).to eq %i(a f w h)
    end

    context 'with at least one word' do
      before do
        add_words node, %w(all the words)
      end

      it 'keeps the node letter nil' do
        compressed = compressor.compress node

        expect(compressed.letter).to be_nil
      end
    end

    context 'with a single word' do
      before do
        add_word node, 'all'
      end

      it 'compresses into a single node without children' do
        compressed = compressor.compress node

        expect(compressed[:a].letter).to eq :all
        expect(compressed[:a].children.size).to eq 0
        expect(compressed[:a]).to be_terminal
        expect(compressed[:a]).to be_compressed
      end
    end

    context 'with two words' do
      before do
        add_words node, %w(all ask)
      end

      it 'compresses into corresponding three nodes' do
        compressed = compressor.compress node

        expect(compressed[:a].letter).to eq :a
        expect(compressed[:a].children.size).to eq 2

        expect(compressed[:a][:l].letter).to eq :ll
        expect(compressed[:a][:s].letter).to eq :sk

        expect(compressed[:a][:l].children.size).to eq 0
        expect(compressed[:a][:s].children.size).to eq 0

        expect(compressed[:a][:l]).to be_terminal
        expect(compressed[:a][:s]).to be_terminal

        expect(compressed[:a][:l]).to be_compressed
        expect(compressed[:a][:s]).to be_compressed
      end
    end

    it 'reassigns the parent nodes correctly' do
      add_words node, %w(repay rest repaint)
      compressed = compressor.compress node

      expect(compressed[:r].letter).to eq :re
      expect(compressed[:r].parent).to eq compressed
      expect(compressed[:r].children.size).to eq 2

      expect(compressed[:r][:p].letter).to eq :pa
      expect(compressed[:r][:p].parent).to eq compressed[:r]
      expect(compressed[:r][:p].children.size).to eq 2

      expect(compressed[:r][:s].letter).to eq :st
      expect(compressed[:r][:s].parent).to eq compressed[:r]
      expect(compressed[:r][:s].children.size).to eq 0

      expect(compressed[:r][:p][:y].letter).to eq :y
      expect(compressed[:r][:p][:y].parent).to eq compressed[:r][:p]
      expect(compressed[:r][:p][:y].children.size).to eq 0

      expect(compressed[:r][:p][:i].letter).to eq :int
      expect(compressed[:r][:p][:i].parent).to eq compressed[:r][:p]
      expect(compressed[:r][:p][:i].children.size).to eq 0
    end

    it 'does not compress terminal nodes' do
      add_words node, %w(you your yours)
      compressed = compressor.compress node

      expect(compressed[:y].letter).to eq :you

      expect(compressed[:y][:r].letter).to eq :r
      expect(compressed[:y][:r]).to be_compressed

      expect(compressed[:y][:r][:s].letter).to eq :s
      expect(compressed[:y][:r][:s]).to be_compressed
    end
  end
end
