require 'spec_helper'

module Rambling
  module Trie
    describe Root do
      let(:root) { Root.new }

      describe '.new' do
        context 'without filename' do
          it 'has no letter' do
            expect(root.letter).to be_nil
          end

          it 'is not a terminal node' do
            expect(root).to_not be_terminal
          end

          it 'has no children' do
            expect(root).to have(0).children
          end

          it 'is not a word' do
            expect(root.word?).to be_false
          end
        end

        context 'with a filename' do
          let(:filename) { File.join(::SPEC_ROOT, 'assets', 'test_words.txt') }
          let(:root) { Root.new filename }

          it 'has the expected root children' do
            File.open(filename) do |file|
              expected_hash = Hash[file.readlines.map { |x| [x.slice(0).to_sym, nil] }]
              expect(root).to have(expected_hash.length).children
              expect(root.children.keys).to match_array expected_hash.keys
            end
          end

          it 'loads every word' do
            File.open filename do |file|
              file.readlines.each { |word| expect(root).to include word.chomp }
            end
          end

          context 'and compressed' do
            before do
              root.compress!
            end

            it 'is marked as compressed' do
              expect(root).to be_compressed
            end

            it 'compresses the root nodes' do
              expect(root[:t].letter).to eq :t
              expect(root[:t].children.size).to eq 2

              expect(root[:t][:ru].letter).to eq :ru
              expect(root[:t][:ru].children.size).to eq 2

              expect(root[:t][:ru][:e]).to be_terminal
              expect(root[:t][:ru][:e]).to be_compressed
            end
          end
        end
      end

      describe '#compress!' do
        it 'returns itself marked as compressed' do
          compressed_root = root.compress!

          expect(compressed_root).to eq root
          expect(compressed_root).to be_compressed
        end

        context 'after calling #compress! once' do
          it 'keeps returning itself' do
            compressed_root = root.compress!.compress!

            expect(compressed_root).to eq root
            expect(compressed_root).to be_compressed
          end
        end

        context 'with at least one word' do
          it 'keeps the root letter nil' do
            root.add_branch 'all'
            root.compress!

            expect(root.letter).to be_nil
          end
        end

        context 'with a single word' do
          before do
            root.add_branch 'all'
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
            root.add_branch 'all'
            root.add_branch 'ask'
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
          root.add_branch 'repay'
          root.add_branch 'rest'
          root.add_branch 'repaint'
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
          root.add_branch 'you'
          root.add_branch 'your'
          root.add_branch 'yours'

          root.compress!

          expect(root[:you].letter).to eq :you

          expect(root[:you][:r].letter).to eq :r
          expect(root[:you][:r]).to be_compressed

          expect(root[:you][:r][:s].letter).to eq :s
          expect(root[:you][:r][:s]).to be_compressed
        end

        describe 'and trying to add a branch' do
          it 'raises an error' do
            root.add_branch 'repay'
            root.add_branch 'rest'
            root.add_branch 'repaint'
            root.compress!

            expect { root.add_branch('restaurant') }.to raise_error InvalidOperation
          end
        end
      end

      describe '#word?' do
        context 'word is contained' do
          before do
            root.add_branch 'hello'
            root.add_branch 'high'
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
            root.add_branch 'hello'
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
            root.add_branch 'hello'
            root.add_branch 'high'
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
            root.add_branch 'hello'
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

      describe '#has_branch_for?' do
        let(:root) { Root.new }
        let(:word) { 'word' }

        before do
          root.stub(:warn)
          root.stub(:has_branch?)
        end

        it 'warns about deprecation' do
          root.should_receive(:warn)
          root.has_branch_for? word
        end

        it 'delegates to #has_branch?' do
          [true, false].each do |value|
            root.should_receive(:has_branch?).and_return value
            expect(root.has_branch_for? word).to eq value
          end
        end
      end

      describe '#is_word?' do
        let(:root) { Root.new }
        let(:word) { 'word' }

        before do
          root.stub(:warn)
          root.stub(:word?)
        end

        it 'warns about deprecation' do
          root.should_receive(:warn)
          root.is_word? word
        end

        it 'delegates to #word?' do
          [true, false].each do |value|
            root.stub(:word?).and_return value
            expect(root.is_word? word).to eq value
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
