require 'spec_helper'

describe Rambling::Trie::Compressor do
  let(:compressor) { Rambling::Trie::Compressor.new }

  describe '#compress' do
    let(:node) { Rambling::Trie::Nodes::Raw.new }

    it 'compresses the node' do
      add_words node, %w(a few words hello hell)
      compressed = compressor.compress node

      expect(compressed.children_tree.keys).to eq %i(a few words hell)
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

        expect(compressed[:all].letter).to eq :all
        expect(compressed[:all].children.size).to eq 0
        expect(compressed[:all]).to be_terminal
        expect(compressed[:all]).to be_compressed
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

        expect(compressed[:a][:ll].letter).to eq :ll
        expect(compressed[:a][:sk].letter).to eq :sk

        expect(compressed[:a][:ll].children.size).to eq 0
        expect(compressed[:a][:sk].children.size).to eq 0

        expect(compressed[:a][:ll]).to be_terminal
        expect(compressed[:a][:sk]).to be_terminal

        expect(compressed[:a][:ll]).to be_compressed
        expect(compressed[:a][:sk]).to be_compressed
      end
    end

    it 'reassigns the parent nodes correctly' do
      add_words node, %w(repay rest repaint)
      compressed = compressor.compress node

      expect(compressed[:re].letter).to eq :re
      expect(compressed[:re].parent).to eq compressed
      expect(compressed[:re].children.size).to eq 2

      expect(compressed[:re][:pa].letter).to eq :pa
      expect(compressed[:re][:pa].parent).to eq compressed[:re]
      expect(compressed[:re][:pa].children.size).to eq 2

      expect(compressed[:re][:st].letter).to eq :st
      expect(compressed[:re][:st].parent).to eq compressed[:re]
      expect(compressed[:re][:st].children.size).to eq 0

      expect(compressed[:re][:pa][:y].letter).to eq :y
      expect(compressed[:re][:pa][:y].parent).to eq compressed[:re][:pa]
      expect(compressed[:re][:pa][:y].children.size).to eq 0

      expect(compressed[:re][:pa][:int].letter).to eq :int
      expect(compressed[:re][:pa][:int].parent).to eq compressed[:re][:pa]
      expect(compressed[:re][:pa][:int].children.size).to eq 0
    end

    it 'does not compress terminal nodes' do
      add_words node, %w(you your yours)
      compressed = compressor.compress node

      expect(compressed[:you].letter).to eq :you

      expect(compressed[:you][:r].letter).to eq :r
      expect(compressed[:you][:r]).to be_compressed

      expect(compressed[:you][:r][:s].letter).to eq :s
      expect(compressed[:you][:r][:s]).to be_compressed
    end
  end
end
