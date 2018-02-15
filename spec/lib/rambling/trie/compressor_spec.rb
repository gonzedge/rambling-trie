require 'spec_helper'

describe Rambling::Trie::Compressor do
  let(:compressor) { Rambling::Trie::Compressor.new }

  describe '#compress' do
    let(:root) { Rambling::Trie::Nodes::Raw.new }

    it 'compresses the new root' do
      words = %w(a few words hello hell)
      words.each { |word| root.add word.chars.reverse.map(&:to_sym) }
      compressed_root = compressor.compress root

      expect(compressed_root.children_tree.keys).to eq %i(a few words hell)
    end

    context 'with at least one word' do
      before do
        %w(all).each do |word|
          root.add word.chars.reverse.map(&:to_sym)
        end
      end

      it 'keeps the root letter nil' do
        compressed_root = compressor.compress root

        expect(compressed_root.letter).to be_nil
      end
    end

    context 'with a single word' do
      before do
        %w(all).each do |word|
          root.add word.chars.reverse.map(&:to_sym)
        end
      end

      it 'compresses into a single node without children' do
        compressed_root = compressor.compress root

        expect(compressed_root[:all].letter).to eq :all
        expect(compressed_root[:all].children.size).to eq 0
        expect(compressed_root[:all]).to be_terminal
        expect(compressed_root[:all]).to be_compressed
      end
    end

    context 'with two words' do
      before do
        %w(all ask).each do |word|
          root.add word.chars.reverse.map(&:to_sym)
        end
      end

      it 'compresses into corresponding three nodes' do
        compressed_root = compressor.compress root

        expect(compressed_root[:a].letter).to eq :a
        expect(compressed_root[:a].children.size).to eq 2

        expect(compressed_root[:a][:ll].letter).to eq :ll
        expect(compressed_root[:a][:sk].letter).to eq :sk

        expect(compressed_root[:a][:ll].children.size).to eq 0
        expect(compressed_root[:a][:sk].children.size).to eq 0

        expect(compressed_root[:a][:ll]).to be_terminal
        expect(compressed_root[:a][:sk]).to be_terminal

        expect(compressed_root[:a][:ll]).to be_compressed
        expect(compressed_root[:a][:sk]).to be_compressed
      end
    end

    it 'reassigns the parent nodes correctly' do
      %w(repay rest repaint).each do |word|
        root.add word.chars.reverse.map(&:to_sym)
      end

      compressed_root = compressor.compress root

      expect(compressed_root[:re].letter).to eq :re
      expect(compressed_root[:re].parent).to eq compressed_root
      expect(compressed_root[:re].children.size).to eq 2

      expect(compressed_root[:re][:pa].letter).to eq :pa
      expect(compressed_root[:re][:pa].parent).to eq compressed_root[:re]
      expect(compressed_root[:re][:pa].children.size).to eq 2

      expect(compressed_root[:re][:st].letter).to eq :st
      expect(compressed_root[:re][:st].parent).to eq compressed_root[:re]
      expect(compressed_root[:re][:st].children.size).to eq 0

      expect(compressed_root[:re][:pa][:y].letter).to eq :y
      expect(compressed_root[:re][:pa][:y].parent).to eq compressed_root[:re][:pa]
      expect(compressed_root[:re][:pa][:y].children.size).to eq 0

      expect(compressed_root[:re][:pa][:int].letter).to eq :int
      expect(compressed_root[:re][:pa][:int].parent).to eq compressed_root[:re][:pa]
      expect(compressed_root[:re][:pa][:int].children.size).to eq 0
    end

    it 'does not compress terminal nodes' do
      %w(you your yours).each do |word|
        root.add word.chars.reverse.map(&:to_sym)
      end

      compressed_root = compressor.compress root

      expect(compressed_root[:you].letter).to eq :you

      expect(compressed_root[:you][:r].letter).to eq :r
      expect(compressed_root[:you][:r]).to be_compressed

      expect(compressed_root[:you][:r][:s].letter).to eq :s
      expect(compressed_root[:you][:r][:s]).to be_compressed
    end
  end
end
