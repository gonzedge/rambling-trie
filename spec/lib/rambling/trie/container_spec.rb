require 'spec_helper'

describe Rambling::Trie::Container do
  let(:container) { Rambling::Trie::Container.new root, compressor }
  let(:compressor) { Rambling::Trie::Compressor.new }
  let(:root) { Rambling::Trie::RawNode.new }

  describe '.new' do
    context 'without a specified root' do
      before do
        allow(Rambling::Trie::RawNode).to receive(:new)
          .and_return root
      end

      it 'initializes an empty trie root node' do
        Rambling::Trie::Container.new
        expect(Rambling::Trie::RawNode).to have_received :new
      end
    end

    context 'without a specified compressor' do
      before do
        allow(Rambling::Trie::Compressor).to receive(:new)
          .and_return compressor
      end

      it 'initializes a compressor' do
        Rambling::Trie::Container.new
        expect(Rambling::Trie::Compressor).to have_received :new
      end
    end

    context 'with a block' do
      it 'yields the container' do
        yielded_container = nil

        container = Rambling::Trie::Container.new root do |container|
          yielded_container = container
        end

        expect(yielded_container).to eq container
      end
    end
  end

  describe '#add' do
    let(:clone) { double :clone }
    let(:word) { double :word, clone: clone }

    before do
      allow(root).to receive(:add)
    end

    it 'clones the original word' do
      container.add word
      expect(root).to have_received(:add).with clone
    end
  end

  describe '#compress!' do
    let(:node) { double :node, add: nil, compressed?: false }

    before do
      allow(compressor).to receive(:compress).and_return node
      allow(root).to receive(:add)
    end

    it 'compresses the trie using the compressor' do
      container.compress!

      expect(compressor).to have_received(:compress)
        .with root
    end

    it 'changes to the root returned by the compressor' do
      container.compress!
      container.add 'word'

      expect(root).not_to have_received :add
      expect(node).to have_received :add
    end

    it 'returns itself' do
      expect(container.compress!).to eq container
    end

    it 'does not compress multiple times' do
      container.compress!
      allow(node).to receive(:compressed?).and_return(true)

      container.compress!
      expect(compressor).to have_received(:compress).once
    end
  end

  describe '#word?' do
    context 'for an uncompressed root' do
      let(:root) do
        double :root,
          compressed?: false,
          word?: nil
      end

      it 'calls the root with the word characters' do
        container.word? 'words'
        expect(root).to have_received(:word?).with %w(w o r d s)
      end
    end

    context 'for a compressed root' do
      let(:root) do
        double :root,
          compressed?: true,
          word?: nil
      end

      it 'calls the root with the full word' do
        container.word? 'words'
        expect(root).to have_received(:word?).with %w(w o r d s)
      end
    end
  end

  describe '#partial_word?' do
    context 'for an uncompressed root' do
      let(:root) do
        double :root,
          compressed?: false,
          partial_word?: nil
      end

      it 'calls the root with the word characters' do
        container.partial_word? 'words'
        expect(root).to have_received(:partial_word?).with %w(w o r d s)
      end
    end

    context 'for a compressed root' do
      let(:root) do
        double :root,
          compressed?: true,
          partial_word?: nil
      end

      it 'calls the root with the word characters' do
        container.partial_word? 'words'
        expect(root).to have_received(:partial_word?).with %w(w o r d s)
      end
    end
  end

  describe 'delegates and aliases' do
    before do
      allow(root).to receive_messages(
        word?: nil,
        partial_word?: nil,
        scan: nil,
        add: nil,
        each: nil,
        compressed?: nil
      )
    end

    it 'aliases `#include?` to `#word?`' do
      container.include? 'words'
      expect(root).to have_received(:word?).with %w(w o r d s)
    end

    it 'aliases `#match?` to `#partial_word?`' do
      container.match? 'words'
      expect(root).to have_received(:partial_word?).with %w(w o r d s)
    end

    it 'aliases `#words` to `#scan`' do
      container.words 'hig'
      expect(root).to have_received(:scan).with %w(h i g)
    end

    it 'aliases `#<<` to `#add`' do
      container << 'words'
      expect(root).to have_received(:add).with 'words'
    end

    it 'delegates `#each` to the root node' do
      container.each
      expect(root).to have_received :each
    end

    it 'delegates `#compressed?` to the root node' do
      container.compressed?
      expect(root).to have_received :compressed?
    end
  end

  describe '#compress!' do
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:root) { Rambling::Trie::RawNode.new }

    context 'with at least one word' do
      it 'keeps the root letter nil' do
        container.add 'all'
        container.compress!

        expect(container.letter).to be_nil
      end
    end

    context 'with a single word' do
      before do
        container.add 'all'
        container.compress!
      end

      it 'compresses into a single node without children' do
        expect(container[:all].letter).to eq :all
        expect(container[:all].children.size).to eq 0
        expect(container[:all]).to be_terminal
        expect(container[:all]).to be_compressed
      end
    end

    context 'with two words' do
      before do
        container.add 'all'
        container.add 'ask'
        container.compress!
      end

      it 'compresses into corresponding three nodes' do
        expect(container[:a].letter).to eq :a
        expect(container[:a].children.size).to eq 2

        expect(container[:a][:ll].letter).to eq :ll
        expect(container[:a][:sk].letter).to eq :sk

        expect(container[:a][:ll].children.size).to eq 0
        expect(container[:a][:sk].children.size).to eq 0

        expect(container[:a][:ll]).to be_terminal
        expect(container[:a][:sk]).to be_terminal

        expect(container[:a][:ll]).to be_compressed
        expect(container[:a][:sk]).to be_compressed
      end
    end

    it 'reassigns the parent nodes correctly' do
      container.add 'repay'
      container.add 'rest'
      container.add 'repaint'
      container.compress!

      expect(container[:re].letter).to eq :re
      expect(container[:re].children.size).to eq 2

      expect(container[:re][:pa].letter).to eq :pa
      expect(container[:re][:st].letter).to eq :st

      expect(container[:re][:pa].children.size).to eq 2
      expect(container[:re][:st].children.size).to eq 0

      expect(container[:re][:pa][:y].letter).to eq :y
      expect(container[:re][:pa][:int].letter).to eq :int

      expect(container[:re][:pa][:y].children.size).to eq 0
      expect(container[:re][:pa][:int].children.size).to eq 0

      expect(container[:re][:pa][:y].parent).to eq container[:re][:pa]
      expect(container[:re][:pa][:int].parent).to eq container[:re][:pa]
    end

    it 'does not compress terminal nodes' do
      container.add 'you'
      container.add 'your'
      container.add 'yours'

      container.compress!

      expect(container[:you].letter).to eq :you

      expect(container[:you][:r].letter).to eq :r
      expect(container[:you][:r]).to be_compressed

      expect(container[:you][:r][:s].letter).to eq :s
      expect(container[:you][:r][:s]).to be_compressed
    end

    describe 'and trying to add a word' do
      it 'raises an error' do
        container.add 'repay'
        container.add 'rest'
        container.add 'repaint'
        container.compress!

        expect { container.add 'restaurant' }.to raise_error Rambling::Trie::InvalidOperation
      end
    end
  end

  describe '#word?' do
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:root) { Rambling::Trie::RawNode.new }

    context 'word is contained' do
      before do
        container.add 'hello'
        container.add 'high'
      end

      it 'matches the whole word' do
        expect(container.word? 'hello').to be true
        expect(container.word? 'high').to be true
      end

      context 'and the root has been compressed' do
        before do
          container.compress!
        end

        it 'matches the whole word' do
          expect(container.word? 'hello').to be true
          expect(container.word? 'high').to be true
        end
      end
    end

    context 'word is not contained' do
      before do
        container.add 'hello'
      end

      it 'does not match the whole word' do
        expect(container.word? 'halt').to be false
        expect(container.word? 'al').to be false
      end

      context 'and the root has been compressed' do
        before do
          container.compress!
        end

        it 'does not match the whole word' do
          expect(container.word? 'halt').to be false
          expect(container.word? 'al').to be false
        end
      end
    end
  end

  describe '#partial_word?' do
    context 'word is contained' do
      before do
        container.add 'hello'
        container.add 'high'
      end

      it 'matches part of the word' do
        expect(container.partial_word? 'hell').to be true
        expect(container.partial_word? 'hig').to be true
      end

      context 'and the root has been compressed' do
        before do
          container.compress!
        end

        it 'matches part of the word' do
          expect(container.partial_word? 'h').to be true
          expect(container.partial_word? 'he').to be true
          expect(container.partial_word? 'hell').to be true
          expect(container.partial_word? 'hello').to be true
          expect(container.partial_word? 'hi').to be true
          expect(container.partial_word? 'hig').to be true
          expect(container.partial_word? 'high').to be true
        end
      end
    end

    context 'word is not contained' do
      before do
        container.add 'hello'
      end

      it 'does not match any part of the word' do
        expect(container.partial_word? 'ha').to be false
        expect(container.partial_word? 'hal').to be false
        expect(container.partial_word? 'al').to be false
      end

      context 'and the root has been compressed' do
        before do
          container.compress!
        end

        it 'does not match any part of the word' do
          expect(container.partial_word? 'ha').to be false
          expect(container.partial_word? 'hal').to be false
          expect(container.partial_word? 'al').to be false
        end
      end
    end
  end

  describe '#scan' do
    context 'words that match are not contained' do
      before do
        container.add 'hi'
        container.add 'hello'
        container.add 'high'
        container.add 'hell'
        container.add 'highlight'
        container.add 'histerical'
      end

      it 'returns an array with the words that match' do
        expect(container.scan 'hi').to eq [
          'hi',
          'high',
          'highlight',
          'histerical'
        ]

        expect(container.scan 'hig').to eq [
          'high',
          'highlight'
        ]
      end

      context 'and the root has been compressed' do
        before do
          container.compress!
        end

        it 'returns an array with the words that match' do
          expect(container.scan 'hi').to eq [
            'hi',
            'high',
            'highlight',
            'histerical'
          ]

          expect(container.scan 'hig').to eq [
            'high',
            'highlight'
          ]
        end
      end
    end

    context 'words that match are not contained' do
      before do
        container.add 'hello'
      end

      it 'returns an empty array' do
        expect(container.scan 'hi').to eq []
      end

      context 'and the root has been compressed' do
        before do
          container.compress!
        end

        it 'returns an empty array' do
          expect(container.scan 'hi').to eq []
        end
      end
    end
  end
end
