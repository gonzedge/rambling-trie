require 'spec_helper'

module Rambling
  module Trie
    describe Root do
      describe '#root?' do
        it 'returns true' do
          expect(subject).to be_root
        end
      end

      describe '.new' do
        it 'has no children' do
          expect(subject.children.size).to eq 0
        end

        it 'has no letter' do
          expect(subject.letter).to be_nil
        end

        it 'is not a terminal node' do
          expect(subject).not_to be_terminal
        end

        it 'is not a word' do
          expect(subject).not_to be_word
        end
      end

      describe '#compress!' do
        let(:compressed_root) { subject.compress! }

        it 'returns itself marked as compressed' do
          expect(compressed_root).to eq subject
          expect(compressed_root).to be_compressed
        end

        context 'after calling #compress! once' do
          let(:recompressed_root) { compressed_root.compress! }

          it 'keeps returning itself' do
            expect(recompressed_root).to eq subject
            expect(recompressed_root).to be_compressed
          end
        end

        context 'with at least one word' do
          it 'keeps the root letter nil' do
            subject << 'all'
            subject.compress!

            expect(subject.letter).to be_nil
          end
        end

        context 'with a single word' do
          before do
            subject << 'all'
            subject.compress!
          end

          it 'compresses into a single node without children' do
            expect(subject[:all].letter).to eq :all
            expect(subject[:all].children.size).to eq 0
            expect(subject[:all]).to be_terminal
            expect(subject[:all]).to be_compressed
          end
        end

        context 'with two words' do
          before do
            subject << 'all'
            subject << 'ask'
            subject.compress!
          end

          it 'compresses into corresponding three nodes' do
            expect(subject[:a].letter).to eq :a
            expect(subject[:a].children.size).to eq 2

            expect(subject[:a][:ll].letter).to eq :ll
            expect(subject[:a][:sk].letter).to eq :sk

            expect(subject[:a][:ll].children.size).to eq 0
            expect(subject[:a][:sk].children.size).to eq 0

            expect(subject[:a][:ll]).to be_terminal
            expect(subject[:a][:sk]).to be_terminal

            expect(subject[:a][:ll]).to be_compressed
            expect(subject[:a][:sk]).to be_compressed
          end
        end

        it 'reassigns the parent nodes correctly' do
          subject << 'repay'
          subject << 'rest'
          subject << 'repaint'
          subject.compress!

          expect(subject[:re].letter).to eq :re
          expect(subject[:re].children.size).to eq 2

          expect(subject[:re][:pa].letter).to eq :pa
          expect(subject[:re][:st].letter).to eq :st

          expect(subject[:re][:pa].children.size).to eq 2
          expect(subject[:re][:st].children.size).to eq 0

          expect(subject[:re][:pa][:y].letter).to eq :y
          expect(subject[:re][:pa][:int].letter).to eq :int

          expect(subject[:re][:pa][:y].children.size).to eq 0
          expect(subject[:re][:pa][:int].children.size).to eq 0

          expect(subject[:re][:pa][:y].parent).to eq subject[:re][:pa]
          expect(subject[:re][:pa][:int].parent).to eq subject[:re][:pa]
        end

        it 'does not compress terminal nodes' do
          subject << 'you'
          subject << 'your'
          subject << 'yours'

          subject.compress!

          expect(subject[:you].letter).to eq :you

          expect(subject[:you][:r].letter).to eq :r
          expect(subject[:you][:r]).to be_compressed

          expect(subject[:you][:r][:s].letter).to eq :s
          expect(subject[:you][:r][:s]).to be_compressed
        end

        describe 'and trying to add a word' do
          it 'raises an error' do
            subject << 'repay'
            subject << 'rest'
            subject << 'repaint'
            subject.compress!

            expect { subject << 'restaurant' }.to raise_error InvalidOperation
          end
        end
      end

      describe '#word?' do
        context 'word is contained' do
          before do
            subject << 'hello'
            subject << 'high'
          end

          it 'matches the whole word' do
            expect(subject.word? 'hello').to be true
            expect(subject.word? 'high').to be true
          end

          context 'and the root has been compressed' do
            before do
              subject.compress!
            end

            it 'matches the whole word' do
              expect(subject.word? 'hello').to be true
              expect(subject.word? 'high').to be true
            end
          end
        end

        context 'word is not contained' do
          before do
            subject << 'hello'
          end

          it 'does not match the whole word' do
            expect(subject.word? 'halt').to be false
            expect(subject.word? 'al').to be false
          end

          context 'and the root has been compressed' do
            before do
              subject.compress!
            end

            it 'does not match the whole word' do
              expect(subject.word? 'halt').to be false
              expect(subject.word? 'al').to be false
            end
          end
        end
      end

      describe '#partial_word?' do
        context 'word is contained' do
          before do
            subject << 'hello'
            subject << 'high'
          end

          it 'matches part of the word' do
            expect(subject.partial_word? 'hell').to be true
            expect(subject.partial_word? 'hig').to be true
          end

          context 'and the root has been compressed' do
            before do
              subject.compress!
            end

            it 'matches part of the word' do
              expect(subject.partial_word? 'h').to be true
              expect(subject.partial_word? 'he').to be true
              expect(subject.partial_word? 'hell').to be true
              expect(subject.partial_word? 'hello').to be true
              expect(subject.partial_word? 'hi').to be true
              expect(subject.partial_word? 'hig').to be true
              expect(subject.partial_word? 'high').to be true
            end
          end
        end

        context 'word is not contained' do
          before do
            subject << 'hello'
          end

          it 'does not match any part of the word' do
            expect(subject.partial_word? 'ha').to be false
            expect(subject.partial_word? 'hal').to be false
            expect(subject.partial_word? 'al').to be false
          end

          context 'and the root has been compressed' do
            before do
              subject.compress!
            end

            it 'does not match any part of the word' do
              expect(subject.partial_word? 'ha').to be false
              expect(subject.partial_word? 'hal').to be false
              expect(subject.partial_word? 'al').to be false
            end
          end
        end
      end

      describe '#scan' do
        context 'words that match are not contained' do
          before do
            subject << 'hi'
            subject << 'hello'
            subject << 'high'
            subject << 'hell'
            subject << 'highlight'
            subject << 'histerical'
          end

          it 'returns an array with the words that match' do
            expect(subject.scan 'hi').to eq [
              'hi',
              'high',
              'highlight',
              'histerical'
            ]

            expect(subject.scan 'hig').to eq [
              'high',
              'highlight'
            ]
          end

          context 'and the root has been compressed' do
            before do
              subject.compress!
            end

            it 'returns an array with the words that match' do
              expect(subject.scan 'hi').to eq [
                'hi',
                'high',
                'highlight',
                'histerical'
              ]

              expect(subject.scan 'hig').to eq [
                'high',
                'highlight'
              ]
            end
          end
        end

        context 'words that match are not contained' do
          before do
            subject << 'hello'
          end

          it 'returns an empty array' do
            expect(subject.scan 'hi').to eq []
          end

          context 'and the root has been compressed' do
            before do
              subject.compress!
            end

            it 'returns an empty array' do
              expect(subject.scan 'hi').to eq []
            end
          end
        end
      end

      describe '#add' do
        let(:original_word) { 'word' }
        let(:word) { original_word.clone }

        it 'does not change the original word' do
          subject.add word
          expect(word).to eq original_word
        end

        it 'is still aliased as #<<' do
          subject << word
          expect(word).to eq original_word
        end
      end
    end
  end
end
