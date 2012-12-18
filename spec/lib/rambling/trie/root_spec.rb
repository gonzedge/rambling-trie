require 'spec_helper'

module Rambling
  module Trie
    describe Root do
      let(:root) { Root.new }

      describe '.new' do
        it 'has no children' do
          expect(root).to have(0).children
        end

        it 'has no letter' do
          expect(root.letter).to be_nil
        end

        it 'is not a terminal node' do
          expect(root).to_not be_terminal
        end

        it 'is not a word' do
          expect(root).to_not be_word
        end

        context 'with a block' do
          let(:root) { Root.new { |root| root << 'test' } }

          it 'has no letter' do
            expect(root.letter).to be_nil
          end

          it 'is not a terminal node' do
            expect(root).to_not be_terminal
          end

          it 'is not a word' do
            expect(root).to_not be_word
          end

          it 'executes the block' do
            expect(root).to have(1).children
            expect(root.word? 'test').to be_true
          end
        end
      end

      describe '#compress!' do
        let(:compressed_root) { root.compress! }

        it 'returns itself marked as compressed' do
          expect(compressed_root).to eq root
          expect(compressed_root).to be_compressed
        end

        context 'after calling #compress! once' do
          let(:recompressed_root) { compressed_root.compress! }

          it 'keeps returning itself' do
            expect(recompressed_root).to eq root
            expect(recompressed_root).to be_compressed
          end
        end

        context 'with at least one word' do
          it 'keeps the root letter nil' do
            root << 'all'
            root.compress!

            expect(root.letter).to be_nil
          end
        end

        context 'with a single word' do
          before do
            root << 'all'
            root.compress!
          end

          it 'compresses into a single node without children' do
            expect(root[:all].letter).to eq :all
            expect(root[:all]).to have(0).children
            expect(root[:all]).to be_terminal
            expect(root[:all]).to be_compressed
          end
        end

        context 'with two words' do
          before do
            root << 'all'
            root << 'ask'
            root.compress!
          end

          it 'compresses into corresponding three nodes' do
            expect(root[:a].letter).to eq :a
            expect(root[:a].children.size).to eq 2

            expect(root[:a][:ll].letter).to eq :ll
            expect(root[:a][:sk].letter).to eq :sk

            expect(root[:a][:ll]).to have(0).children
            expect(root[:a][:sk]).to have(0).children

            expect(root[:a][:ll]).to be_terminal
            expect(root[:a][:sk]).to be_terminal

            expect(root[:a][:ll]).to be_compressed
            expect(root[:a][:sk]).to be_compressed
          end
        end

        it 'reassigns the parent nodes correctly' do
          root << 'repay'
          root << 'rest'
          root << 'repaint'
          root.compress!

          expect(root[:re].letter).to eq :re
          expect(root[:re].children.size).to eq 2

          expect(root[:re][:pa].letter).to eq :pa
          expect(root[:re][:st].letter).to eq :st

          expect(root[:re][:pa].children.size).to eq 2
          expect(root[:re][:st]).to have(0).children

          expect(root[:re][:pa][:y].letter).to eq :y
          expect(root[:re][:pa][:int].letter).to eq :int

          expect(root[:re][:pa][:y]).to have(0).children
          expect(root[:re][:pa][:int]).to have(0).children

          expect(root[:re][:pa][:y].parent).to eq root[:re][:pa]
          expect(root[:re][:pa][:int].parent).to eq root[:re][:pa]
        end

        it 'does not compress terminal nodes' do
          root << 'you'
          root << 'your'
          root << 'yours'

          root.compress!

          expect(root[:you].letter).to eq :you

          expect(root[:you][:r].letter).to eq :r
          expect(root[:you][:r]).to be_compressed

          expect(root[:you][:r][:s].letter).to eq :s
          expect(root[:you][:r][:s]).to be_compressed
        end

        describe 'and trying to add a branch' do
          it 'raises an error' do
            root << 'repay'
            root << 'rest'
            root << 'repaint'
            root.compress!

            expect { root << 'restaurant' }.to raise_error InvalidOperation
          end
        end
      end

      describe '#word?' do
        context 'word is contained' do
          before do
            root << 'hello'
            root << 'high'
          end

          it 'matches the whole word' do
            expect(root.word? 'hello').to be_true
            expect(root.word? 'high').to be_true
          end

          it 'is aliased as #include?' do
            expect(root).to include 'hello'
            expect(root).to include 'high'
          end

          context 'and the root has been compressed' do
            before do
              root.compress!
            end

            it 'matches the whole word' do
              expect(root.word? 'hello').to be_true
              expect(root.word? 'high').to be_true
            end
          end
        end

        context 'word is not contained' do
          before do
            root << 'hello'
          end

          it 'does not match the whole word' do
            expect(root.word? 'halt').to be_false
          end

          it 'is aliased as #include?' do
            expect(root).to_not include 'high'
          end

          context 'and the root has been compressed' do
            before do
              root.compress!
            end

            it 'does not match the whole word' do
              expect(root.word? 'halt').to be_false
            end
          end
        end
      end

      describe '#has_branch?' do
        context 'word is contained' do
          before do
            root << 'hello'
            root << 'high'
          end

          it 'matches part of the word' do
            expect(root).to have_branch 'hell'
            expect(root).to have_branch 'hig'
          end

          context 'and the root has been compressed' do
            before do
              root.compress!
            end

            it 'matches part of the word' do
              expect(root).to have_branch 'hell'
              expect(root).to have_branch 'hig'
            end
          end
        end

        context 'word is not contained' do
          before do
            root << 'hello'
          end

          it 'does not match any part of the word' do
            expect(root).to_not have_branch 'ha'
            expect(root).to_not have_branch 'hal'
          end

          context 'and the root has been compressed' do
            before do
              root.compress!
            end

            it 'does not match any part of the word' do
              expect(root).to_not have_branch 'ha'
              expect(root).to_not have_branch 'hal'
            end
          end
        end
      end

      describe '#add_branch' do
        let(:original_word) { 'word' }
        let(:word) { original_word.clone }

        it 'does not change the original word' do
          root.add_branch word
          expect(word).to eq original_word
        end

        it 'is still aliased as #<<' do
          root << word
          expect(word).to eq original_word
        end
      end
    end
  end
end
