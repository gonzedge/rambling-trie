# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Container do
  subject(:container) { described_class.new root, compressor }

  let(:compressor) { Rambling::Trie::Compressor.new }
  let(:root) { Rambling::Trie::Nodes::Raw.new }

  describe '.new' do
    it 'uses the provided node as root' do
      expect(container.root).to be root
    end

    context 'with a block' do
      it 'yields the container' do
        yielded = nil

        container = described_class.new root, compressor do |c|
          yielded = c
        end

        expect(yielded).to be container
      end
    end
  end

  describe '#add' do
    # rubocop:disable RSpec/MultipleExpectations
    it 'adds the word to the root node' do
      add_word container, 'hello'

      expect(root.children.size).to eq 1
      expect(root.to_a).to eq %w(hello)
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe '#concat' do
    # rubocop:disable RSpec/MultipleExpectations
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
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe '#compress' do
    let(:node) { Rambling::Trie::Nodes::Compressed.new }

    before do
      allow(compressor).to receive(:compress).and_return node

      add_word root, 'yes'
      node[:yes] = Rambling::Trie::Nodes::Compressed.new
    end

    it 'compresses the trie using the compressor' do
      container.compress

      expect(compressor).to have_received(:compress).with root
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'returns a container with the new root' do
      new_container = container.compress

      expect(new_container.root).not_to eq root
      expect(new_container.root).to eq node
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'returns a new container' do
      expect(container.compress).not_to eq container
    end

    it 'can compress multiple times' do
      container.compress
      container.compress

      expect(compressor).to have_received(:compress).twice
    end

    it 'cannot compress the result' do
      new_container = container.compress
      new_container.compress

      expect(compressor).to have_received(:compress).once
    end
  end

  describe '#compress!' do
    let(:node) { Rambling::Trie::Nodes::Compressed.new }

    context 'with a mocked result' do
      before do
        allow(compressor).to receive(:compress).and_return node

        add_word root, 'yes'
        node[:yes] = Rambling::Trie::Nodes::Compressed.new
      end

      it 'compresses the trie using the compressor' do
        container.compress!

        expect(compressor).to have_received(:compress).with root
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'changes to the root returned by the compressor' do
        container.compress!

        expect(container.root).not_to eq root
        expect(container.root).to eq node
      end
      # rubocop:enable RSpec/MultipleExpectations

      it 'returns itself' do
        expect(container.compress!).to eq container
      end

      it 'does not compress multiple times' do
        container.compress!
        allow(node).to receive(:compressed?).and_return(true)

        container.compress!
        expect(compressor).to have_received(:compress).once
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'gets a new root from the compressor' do
        container.compress!

        expect(container.root).not_to be root
        expect(container.root).to be_compressed
        expect(root).not_to be_compressed
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    it 'generates a new root with the words from the passed root' do
      words = %w(a few words hello hell)

      add_words container, words
      container.compress!

      words.each { |word| expect(container).to include word }
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
    [
      [true, 'Rambling::Trie::Nodes::Compressed'],
      [false, 'Rambling::Trie::Nodes::Raw'],
    ].each do |test_params|
      compressed_value, instance_double_class = test_params

      context "when root has compressed=#{compressed_value}" do
        let(:root) do
          instance_double(
            instance_double_class,
            :root,
            compressed?: compressed_value,
            word?: nil,
          )
        end

        it 'calls the root with the word characters' do
          container.word? 'words'
          expect(root).to have_received(:word?).with %w(w o r d s)
        end
      end
    end

    context 'when word is contained' do
      before { add_words container, %w(hello high) }

      %w(hello high).each do |word|
        it 'matches the whole word' do
          expect(container.word? word).to be true
        end
      end

      context 'with compressed root' do
        before { container.compress! }

        %w(hello high).each do |word|
          it 'matches the whole word' do
            expect(container.word? word).to be true
          end
        end
      end
    end

    context 'when word is not contained' do
      before { add_word container, 'hello' }

      %w(halt al).each do |word|
        it 'does not match the whole word' do
          expect(container.word? word).to be false
        end
      end

      context 'with compressed root' do
        before { container.compress! }

        %w(halt al).each do |word|
          it 'does not match the whole word' do
            expect(container.word? word).to be false
          end
        end
      end
    end
  end

  describe '#partial_word?' do
    [
      [true, 'Rambling::Trie::Nodes::Compressed'],
      [false, 'Rambling::Trie::Nodes::Raw'],
    ].each do |test_params|
      compressed_value, instance_double_class = test_params

      context "when root has compressed=#{compressed_value}" do
        let(:root) do
          instance_double(
            instance_double_class,
            :root,
            compressed?: compressed_value,
            partial_word?: nil,
          )
        end

        it 'calls the root with the word characters' do
          container.partial_word? 'words'
          expect(root).to have_received(:partial_word?).with %w(w o r d s)
        end
      end
    end

    context 'when word is contained' do
      before { add_words container, %w(hello high) }

      %w(h he hell hello hi hig high).each do |prefix|
        it 'matches part of the word' do
          expect(container.partial_word? prefix).to be true
        end
      end

      context 'with compressed root' do
        before { container.compress! }

        %w(h he hell hello hi hig high).each do |prefix|
          it 'matches part of the word' do
            expect(container.partial_word? prefix).to be true
          end
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

    context 'when word is not contained' do
      before { add_word container, 'hello' }

      context 'with uncompressed root' do
        it_behaves_like 'a non matching tree'
      end

      context 'with compressed root' do
        before { container.compress! }

        it_behaves_like 'a non matching tree'
      end
    end
  end

  describe '#scan' do
    context 'when words that match are contained' do
      before do
        add_words container, %w(hi hello high hell highlight histerical)
      end

      [
        ['hi', %w(hi high highlight histerical)],
        ['hig', %w(high highlight)],
      ].each do |test_params|
        prefix, expected = test_params

        it "returns an array with the words that match '#{prefix}'" do
          expect(container.scan prefix).to eq expected
        end
      end

      context 'with compressed root' do
        before { container.compress! }

        [
          ['hi', %w(hi high highlight histerical)],
          ['hig', %w(high highlight)],
        ].each do |test_params|
          prefix, expected = test_params

          it "returns an array with the words that match '#{prefix}'" do
            expect(container.scan prefix).to eq expected
          end
        end
      end
    end

    context 'when words that match are not contained' do
      before { add_word container, 'hello' }

      it 'returns an empty array' do
        expect(container.scan 'hi').to eq %w()
      end

      context 'with compressed root' do
        before { container.compress! }

        it 'returns an empty array' do
          expect(container.scan 'hi').to eq %w()
        end
      end
    end
  end

  describe '#words_within' do
    before { add_words container, %w(one word and other words) }

    context 'when phrase does not contain any words' do
      it 'returns an empty array' do
        expect(container.words_within 'xyz').to match_array []
      end

      context 'with compressed node' do
        before { container.compress! }

        it 'returns an empty array' do
          expect(container.words_within 'xyz').to match_array []
        end
      end
    end

    context 'when phrase contains one word at the start of the phrase' do
      [
        ['word', %w(word)],
        ['wordxyz', %w(word)],
      ].each do |test_params|
        phrase, expected = test_params

        it "returns an array with the word found in the phrase '#{phrase}'" do
          expect(container.words_within phrase).to match_array expected
        end
      end

      context 'with compressed node' do
        before { container.compress! }

        [
          ['word', %w(word)],
          ['wordxyz', %w(word)],
        ].each do |test_params|
          phrase, expected = test_params

          it "returns an array with the word found in the phrase '#{phrase}'" do
            expect(container.words_within phrase).to match_array expected
          end
        end
      end
    end

    context 'when phrase contains one word at the end of the phrase' do
      it 'returns an array with the word found in the phrase' do
        expect(container.words_within 'xyz word').to match_array %w(word)
      end

      context 'with compressed node' do
        before { container.compress! }

        it 'returns an array with the word found in the phrase' do
          expect(container.words_within 'xyz word').to match_array %w(word)
        end
      end
    end

    context 'when phrase contains a few words' do
      it 'returns an array with all words found in the phrase' do
        expect(container.words_within 'xyzword otherzxyone')
          .to match_array %w(word other one)
      end

      context 'with compressed node' do
        before { container.compress! }

        it 'returns an array with all words found in the phrase' do
          expect(container.words_within 'xyzword otherzxyone')
            .to match_array %w(word other one)
        end
      end
    end
  end

  describe '#words_within?' do
    before { add_words container, %w(one word and other words) }

    context 'when phrase does not contain any words' do
      it 'returns false' do
        expect(container.words_within? 'xyz').to be false
      end
    end

    context 'when phrase contains any word' do
      ['xyz words', 'xyzone word'].each do |phrase|
        it "returns true for '#{phrase}'" do
          expect(container.words_within? phrase).to be true
        end
      end
    end
  end

  describe '#==' do
    context 'when the root nodes are the same' do
      let(:other_container) do
        described_class.new container.root, compressor
      end

      it 'returns true' do
        expect(container).to eq other_container
      end
    end

    context 'when the root nodes are not the same' do
      let(:other_root) { Rambling::Trie::Nodes::Raw.new }
      let(:other_container) do
        described_class.new other_root, compressor
      end

      before { add_word other_container, 'hola' }

      it 'returns false' do
        expect(container).not_to eq other_container
      end
    end
  end

  describe '#each' do
    before { add_words container, %w(yes no why) }

    it 'returns an enumerator when no block is given' do
      expect(container.each).to be_instance_of Enumerator
    end

    it 'iterates through all words contained' do
      expect(container.each.to_a).to eq %w(yes no why)
    end
  end

  describe '#inspect' do
    before { add_words container, %w(a few words hello hell) }

    it 'returns the container class name plus the root inspection' do
      expect(container.inspect).to eq one_line <<~CONTAINER
        #<Rambling::Trie::Container root: #<Rambling::Trie::Nodes::Raw letter: nil,
        terminal: nil,
        children: [:a, :f, :w, :h]>>
      CONTAINER
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
        key?: nil,
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

    it 'delegates `#key?` to the root node' do
      container.key? :yup
      expect(root).to have_received(:key?).with :yup
    end

    it 'aliases `#has_key?` to `#key?`' do
      container.has_key? :yup
      expect(root).to have_received(:key?).with :yup
    end

    it 'aliases `#has_letter?` to `#has_key?`' do
      container.has_letter? :yup
      expect(root).to have_received(:key?).with :yup
    end

    it 'delegates `#inspect` to the root node' do
      container.inspect
      expect(root).to have_received :inspect
    end

    it 'delegates `#size` to the root node' do
      container.size
      expect(root).to have_received :size
    end
  end
end
