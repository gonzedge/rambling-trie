require 'spec_helper'

describe Rambling::Trie::Container do
  let(:container) { Rambling::Trie::Container.new root, compressor }
  let(:compressor) { Rambling::Trie::Compressor.new }
  let(:root) { Rambling::Trie::Nodes::Raw.new }

  describe '.new' do
    it 'uses the provided node as root' do
      expect(container.root).to be root
    end

    context 'with a block' do
      it 'yields the container' do
        yielded = nil

        container = Rambling::Trie::Container.new root, compressor do |container|
          yielded = container
        end

        expect(yielded).to be container
      end
    end
  end

  describe '#add' do
    let(:clone) { double :clone }

    before do
      allow(root).to receive(:add)
    end

    it 'clones the original word' do
      container.add 'hello'
      expect(root).to have_received(:add).with %i(o l l e h)
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
        :[] => nil,
        add: nil,
        as_word: nil,
        children: nil,
        children_tree: nil,
        compressed?: nil,
        each: nil,
        has_key?: nil,
        inspect: nil,
        letter: nil,
        parent: nil,
        partial_word?: nil,
        scan: nil,
        size: nil,
        to_s: nil,
        word?: nil,
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
      expect(root).to have_received(:add).with %i(s d r o w)
    end

    it 'delegates `#[]` to the root node' do
      container[:yep]
      expect(root).to have_received(:[]).with :yep
    end

    it 'delegates `#as_word` to the root node' do
      container.as_word
      expect(root).to have_received :as_word
    end

    it 'delegates `#children` to the root node' do
      container.children
      expect(root).to have_received :children
    end

    it 'delegates `#children_tree` to the root node' do
      container.children_tree
      expect(root).to have_received :children_tree
    end

    it 'delegates `#compressed?` to the root node' do
      container.compressed?
      expect(root).to have_received :compressed?
    end

    it 'delegates `#has_key?` to the root node' do
      container.has_key? :yup
      expect(root).to have_received(:has_key?).with :yup
    end

    it 'aliases `#has_letter?` to `#has_key?`' do
      container.has_letter? :yup
      expect(root).to have_received(:has_key?).with :yup
    end

    it 'delegates `#inspect` to the root node' do
      container.inspect
      expect(root).to have_received :inspect
    end

    it 'delegates `#letter` to the root node' do
      container.letter
      expect(root).to have_received :letter
    end

    it 'delegates `#parent` to the root node' do
      container.parent
      expect(root).to have_received :parent
    end

    it 'delegates `#size` to the root node' do
      container.size
      expect(root).to have_received :size
    end

    it 'delegates `#to_s` to the root node' do
      container.to_s
      expect(root).to have_received :to_s
    end
  end

  describe '#compress!' do
    let(:compressor) { Rambling::Trie::Compressor.new }
    let(:root) { Rambling::Trie::Nodes::Raw.new }

    it 'gets a new root from the compressor' do
      container.compress!
      expect(container.root).to be_compressed
    end

    it 'generates a new root with the words from the passed root' do
      words = %w(a few words hello hell)
      words.each { |word| container.add word }
      container.compress!

      words.each { |word| expect(container).to include word }
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
    let(:root) { Rambling::Trie::Nodes::Raw.new }

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
        %w(hi hello high hell highlight histerical).each do |word|
          container.add word
        end
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

  describe '#words_within' do
    before do
      %w(one word and other words).each do |word|
        container.add word
      end
    end

    context 'phrase does not contain any words' do
      it 'returns an empty array' do
        expect(container.words_within 'xyz').to match_array []
      end

      context 'and the node is compressed' do
        before do
          container.compress!
        end

        it 'returns an empty array' do
          expect(container.words_within 'xyz').to match_array []
        end
      end
    end

    context 'phrase contains one word at the start of the phrase' do
      it 'returns an array with the word found in the phrase' do
        expect(container.words_within 'word').to match_array %w(word)
        expect(container.words_within 'wordxyz').to match_array %w(word)
      end

      context 'and the node is compressed' do
        before do
          container.compress!
        end

        it 'returns an array with the word found in the phrase' do
          expect(container.words_within 'word').to match_array %w(word)
          expect(container.words_within 'wordxyz').to match_array %w(word)
        end
      end
    end

    context 'phrase contains one word at the end of the phrase' do
      it 'returns an array with the word found in the phrase' do
        expect(container.words_within 'xyz word').to match_array %w(word)
      end

      context 'and the node is compressed' do
        before do
          container.compress!
        end

        it 'returns an array with the word found in the phrase' do
          expect(container.words_within 'xyz word').to match_array %w(word)
        end
      end
    end

    context 'phrase contains a few words' do
      it 'returns an array with all words found in the phrase' do
        expect(container.words_within 'xyzword otherzxyone').to match_array %w(word other one)
      end

      context 'and the node is compressed' do
        before do
          container.compress!
        end

        it 'returns an array with all words found in the phrase' do
          expect(container.words_within 'xyzword otherzxyone').to match_array %w(word other one)
        end
      end
    end
  end

  describe '#words_within?' do
    before do
      %w(one word and other words).each do |word|
        container.add word
      end
    end

    context 'phrase does not contain any words' do
      it 'returns false' do
        expect(container.words_within? 'xyz').to be false
      end
    end

    context 'phrase contains any word' do
      it 'returns true' do
        expect(container.words_within? 'xyz words').to be true
        expect(container.words_within? 'xyzone word').to be true
      end
    end
  end

  describe '#==' do
    context 'when the root nodes are the same' do
      let(:other_container) { Rambling::Trie::Container.new container.root, compressor }

      it 'returns true' do
        expect(container).to eq other_container
      end
    end

    context 'when the root nodes are not the same' do
      let(:other_root) { Rambling::Trie::Nodes::Raw.new }
      let(:other_container) do
        Rambling::Trie::Container.new other_root, compressor do |c|
          c << 'hola'
        end
      end

      it 'returns false' do
        expect(container).not_to eq other_container
      end
    end
  end

  describe '#each' do
    before do
      root.add %i(s e y)
    end

    it 'returns an enumerator when no block is given' do
      expect(container.each).to be_instance_of Enumerator
    end

    it 'delegates `#each` to the root node when a block is given' do
      expect(container.each.to_a).to eq %w(yes)
    end
  end

  describe '#inspect' do
    before do
      %w(a few words hello hell).each do |word|
        container.add word
      end
    end

    it 'returns the container class name plus the root inspection' do
      expect(container.inspect).to eq '#<Rambling::Trie::Container root: #<Rambling::Trie::Nodes::Raw letter: nil, terminal: nil, children: [:a, :f, :w, :h]>>'
    end
  end
end
