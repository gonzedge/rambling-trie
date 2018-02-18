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
        before do
          add_word_to_tree 'abc'
        end

        it 'returns true' do
          expect(node.partial_word? %w(a)).to be true
          expect(node.partial_word? %w(a b)).to be true
          expect(node.partial_word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match the characters' do
        before do
          add_word_to_tree 'cba'
        end

        it 'returns false' do
          expect(node.partial_word? %w(a)).to be false
          expect(node.partial_word? %w(a b)).to be false
          expect(node.partial_word? %w(a b c)).to be false
        end
      end
    end
  end

  describe '#word?' do
    context 'when the chars array is empty' do
      context 'when the node is terminal' do
        before do
          node.terminal!
        end

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
        before do
          add_word_to_tree 'abc'
        end

        it 'returns true' do
          expect(node.word? %w(a b c)).to be true
        end
      end

      context 'when the node has a tree that does not match all the characters' do
        before do
          add_word_to_tree 'abc'
        end

        it 'returns false' do
          expect(node.word? %w(a)).to be false
          expect(node.word? %w(a b)).to be false
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
      before do
        add_word_to_tree 'cba'
      end

      context 'when the chars are found' do
        it 'returns the found child' do
          expect(node.scan %w(c)).to match_array %w(cba)
          expect(node.scan %w(c b)).to match_array %w(cba)
          expect(node.scan %w(c b a)).to match_array %w(cba)
        end
      end

      context 'when the chars are not found' do
        it 'returns a Nodes::Missing' do
          expect(node.scan %w(a)).to be_a Rambling::Trie::Nodes::Missing
          expect(node.scan %w(a b)).to be_a Rambling::Trie::Nodes::Missing
          expect(node.scan %w(a b c)).to be_a Rambling::Trie::Nodes::Missing
          expect(node.scan %w(c b a d)).to be_a Rambling::Trie::Nodes::Missing
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
      before do
        node.terminal!
      end

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
