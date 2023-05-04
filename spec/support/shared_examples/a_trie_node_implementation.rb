# frozen_string_literal: true

shared_examples_for 'a trie node implementation' do
  it_behaves_like 'a trie node'

  describe '#partial_word?' do
    context 'when the chars array is empty' do
      it 'returns true' do
        expect(node.partial_word? []).to be true
      end
    end

    context 'when the chars array is not empty' do
      context 'when the node has a tree that matches the characters' do
        before { add_word_to_tree 'abc' }

        [%w(a), %w(a b), %w(a b c)].each do |letters|
          it "returns true for '#{letters}'" do
            expect(node.partial_word? letters).to be true
          end
        end
      end

      context 'when the node has a tree that does not match the characters' do
        before { add_word_to_tree 'cba' }

        [%w(a), %w(a b), %w(a b c)].each do |letters|
          it "returns false for '#{letters}'" do
            expect(node.partial_word? letters).to be false
          end
        end
      end
    end
  end

  describe '#word?' do
    context 'when the chars array is empty' do
      context 'when the node is terminal' do
        before { node.terminal! }

        it 'returns true' do
          expect(node.word? []).to be true
        end
      end

      context 'when the node is not terminal' do
        it 'returns false' do
          expect(node.word? []).to be false
        end
      end
    end

    context 'when the chars array is not empty' do
      context 'when the node has a tree that matches all the characters' do
        before { add_word_to_tree 'abc' }

        it 'returns true' do
          expect(node.word? %w(a b c).map(&:dup)).to be true
        end
      end

      context 'when the node subtree does not match all the characters' do
        before { add_word_to_tree 'abc' }

        [%w(a), %w(a b)].each do |letters|
          it "returns false for '#{letters}'" do
            expect(node.word? letters.map(&:dup)).to be false
          end
        end
      end
    end
  end

  describe '#scan' do
    context 'when the chars array is empty' do
      it 'returns itself' do
        expect(node.scan []).to eq node
      end
    end

    context 'when the chars array is not empty' do
      before { add_words_to_tree %w(cba ccab) }

      context 'when the chars are found' do
        [
          [%w(c), %w(cba ccab)],
          [%w(c b), %w(cba)],
          [%w(c b a), %w(cba)],
        ].each do |test_params|
          letters, expected = test_params

          it "returns the corresponding children (#{letters} => #{expected})" do
            expect(node.scan letters).to match_array expected
          end
        end
      end

      context 'when the chars are not found' do
        [
          %w(a),
          %w(a b),
          %w(a b c),
          %w(c a),
          %w(c c b),
          %w(c b a d),
        ].each do |letters|
          it "returns a Nodes::Missing for '#{letters}'" do
            expect(node.scan letters).to be_a Rambling::Trie::Nodes::Missing
          end
        end
      end
    end
  end

  describe '#match_prefix' do
    before do
      assign_letter :i
      add_words_to_tree %w(gnite mport mportant mportantly)
    end

    context 'when the node is terminal' do
      before { node.terminal! }

      it 'adds itself to the words' do
        expect(node.match_prefix %w(g n i t e)).to include 'i'
      end
    end

    context 'when the node is not terminal' do
      it 'does not add itself to the words' do
        expect(node.match_prefix %w(g n i t e)).not_to include 'i'
      end
    end

    context 'when the first few chars match a terminal node' do
      it 'adds those terminal nodes to the words' do
        words = node.match_prefix(%w(m p o r t a n t l y)).to_a
        expect(words).to include 'import', 'important', 'importantly'
      end
    end

    context 'when the first few chars do not match a terminal node' do
      it 'does not add any other words found' do
        words = node.match_prefix(%w(m p m p o r t a n t l y)).to_a
        expect(words).not_to include 'import', 'important', 'importantly'
      end
    end
  end
end
