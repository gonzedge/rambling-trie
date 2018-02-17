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
    it 'adds the word to the root node' do
      add_word container, 'hello'

      expect(root.children.size).to eq 1
      expect(root.to_a).to eq %w(hello)
    end
  end

  describe '#concat' do
    it 'adds all the words to the root node' do
      container.concat %w(other words)

      expect(root.children.size).to eq 2
      expect(root.to_a).to eq %w(other words)
    end

    it 'returns all the corresponding nodes' do
      nodes = container.concat %w(other words)

      expect(nodes.first.letter).to eq :o
      expect(nodes.last.letter).to eq :w
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

      expect(compressor).to have_received(:compress).with root
    end

    it 'changes to the root returned by the compressor' do
      container.compress!
      add_word container, 'word'

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
    let(:root) do
      double :root,
        compressed?: compressed,
        word?: nil
    end

    context 'for an uncompressed root' do
      let(:compressed) { true }

      it 'calls the root with the word characters' do
        container.word? 'words'
        expect(root).to have_received(:word?).with %w(w o r d s)
      end
    end

    context 'for a compressed root' do
      let(:compressed) { false }

      it 'calls the root with the full word' do
        container.word? 'words'
        expect(root).to have_received(:word?).with %w(w o r d s)
      end
    end
  end

  describe '#partial_word?' do
    let(:root) do
      double :root,
        compressed?: compressed,
        partial_word?: nil
    end

    context 'for an uncompressed root' do
      let(:compressed) { true }

      it 'calls the root with the word characters' do
        container.partial_word? 'words'
        expect(root).to have_received(:partial_word?).with %w(w o r d s)
      end
    end

    context 'for a compressed root' do
      let(:compressed) { false }

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
    it 'gets a new root from the compressor' do
      container.compress!

      expect(container.root).not_to be root
      expect(container.root).to be_compressed
      expect(root).not_to be_compressed
    end

    it 'generates a new root with the words from the passed root' do
      words = %w(a few words hello hell)

      add_words container, words
      container.compress!

      words.each do |word|
        expect(container).to include word
      end
    end

    describe 'and trying to add a word' do
      it 'raises an error' do
        add_words container, %w(repay rest repaint)
        container.compress!

        expect do
          add_word container, 'restaurant'
        end.to raise_error Rambling::Trie::InvalidOperation
      end
    end
  end

  describe '#word?' do
    context 'word is contained' do
      before do
        add_words container, %w(hello high)
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
        add_word container, 'hello'
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
        add_words container, %w(hello high)
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

    shared_examples_for 'a non matching tree' do
      it 'does not match any part of the word' do
        %w(ha hal al).each do |word|
          expect(container.partial_word? word).to be false
        end
      end
    end

    context 'word is not contained' do
      before do
        add_word container, 'hello'
      end

      context 'and the root is uncompressed' do
        it_behaves_like 'a non matching tree'
      end

      context 'and the root has been compressed' do
        it_behaves_like 'a non matching tree'
      end
    end
  end

  describe '#scan' do
    context 'words that match are not contained' do
      before do
        add_words container, %w(hi hello high hell highlight histerical)
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
        add_word container, 'hello'
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
      add_words container, %w(one word and other words)
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
      add_words container, %w(one word and other words)
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
      let(:other_container) do
        Rambling::Trie::Container.new container.root, compressor
      end

      it 'returns true' do
        expect(container).to eq other_container
      end
    end

    context 'when the root nodes are not the same' do
      let(:other_root) { Rambling::Trie::Nodes::Raw.new }
      let(:other_container) do
        Rambling::Trie::Container.new other_root, compressor
      end

      before do
        add_word other_container, 'hola'
      end

      it 'returns false' do
        expect(container).not_to eq other_container
      end
    end
  end

  describe '#each' do
    before do
      add_words container, %w(yes no why)
    end

    it 'returns an enumerator when no block is given' do
      expect(container.each).to be_instance_of Enumerator
    end

    it 'iterates through all words contained' do
      expect(container.each.to_a).to eq %w(yes no why)
    end
  end

  describe '#inspect' do
    before do
      add_words container, %w(a few words hello hell)
    end

    it 'returns the container class name plus the root inspection' do
      expect(container.inspect).to eq '#<Rambling::Trie::Container root: #<Rambling::Trie::Nodes::Raw letter: nil, terminal: nil, children: [:a, :f, :w, :h]>>'
    end
  end
end
