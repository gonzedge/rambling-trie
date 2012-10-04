require 'spec_helper'

module Rambling
  module Trie
    describe Root do
      let(:root) { Root.new }

      describe '.new' do
        context 'without filename' do
          it 'has no letter' do
            root.letter.should be_nil
          end

          it 'is not a terminal node' do
            root.should_not be_terminal
          end

          it 'has no children' do
            root.should have(0).children
          end

          it 'is not a word' do
            root.word?.should be_false
          end
        end

        context 'with a filename' do
          let(:filename) { File.join(::SPEC_ROOT, 'assets', 'test_words.txt') }
          let(:root) { Root.new filename }

          it 'has the expected root children' do
            File.open(filename) do |file|
              expected_hash = Hash[file.readlines.map { |x| [x.slice(0).to_sym, nil] }]
              root.should have(expected_hash.length).children
              root.children.map { |k, v| k }.should =~ expected_hash.map { |k, v| k }
            end
          end

          it 'loads every word' do
            File.open filename do |file|
              file.readlines.each { |word| root.word?(word.chomp).should be_true }
            end
          end

          context 'and compressed' do
            before :each do
              root.compress!
            end

            it 'is marked as compressed' do
              root.should be_compressed
            end

            it 'compresses the root nodes' do
              root[:t].letter.should == :t
              root[:t].children.size.should == 2

              root[:t][:ru].letter.should == :ru
              root[:t][:ru].children.size.should == 2

              root[:t][:ru][:e].should be_terminal
              root[:t][:ru][:e].should be_compressed
            end
          end
        end
      end

      describe '#compress!' do
        it 'returns itself marked as compressed' do
          compressed_root = root.compress!

          compressed_root.should == root
          compressed_root.should be_compressed
        end

        context 'after calling #compress! once' do
          it 'keeps returning itself' do
            compressed_root = root.compress!.compress!

            compressed_root.should == root
            compressed_root.should be_compressed
          end
        end

        context 'with at least one word' do
          it 'keeps the root letter nil' do
            root.add_branch 'all'
            root.compress!

            root.letter.should be_nil
          end
        end

        context 'with a single word' do
          before :each do
            root.add_branch 'all'
            root.compress!
          end

          it 'compresses into a single node without children' do
            root[:all].letter.should == :all
            root[:all].should have(0).children
            root[:all].should be_terminal
            root[:all].should be_compressed
          end
        end

        context 'with two words' do
          before :each do
            root.add_branch 'all'
            root.add_branch 'ask'
            root.compress!
          end

          it 'compresses into corresponding three nodes' do
            root[:a].letter.should == :a
            root[:a].children.size.should == 2

            root[:a][:ll].letter.should == :ll
            root[:a][:sk].letter.should == :sk

            root[:a][:ll].should have(0).children
            root[:a][:sk].should have(0).children

            root[:a][:ll].should be_terminal
            root[:a][:sk].should be_terminal

            root[:a][:ll].should be_compressed
            root[:a][:sk].should be_compressed
          end
        end

        it 'reassigns the parent nodes correctly' do
          root.add_branch 'repay'
          root.add_branch 'rest'
          root.add_branch 'repaint'
          root.compress!

          root[:re].letter.should == :re
          root[:re].children.size.should == 2

          root[:re][:pa].letter.should == :pa
          root[:re][:st].letter.should == :st

          root[:re][:pa].children.size.should == 2
          root[:re][:st].should have(0).children

          root[:re][:pa][:y].letter.should == :y
          root[:re][:pa][:int].letter.should == :int

          root[:re][:pa][:y].should have(0).children
          root[:re][:pa][:int].should have(0).children

          root[:re][:pa][:y].parent.should == root[:re][:pa]
          root[:re][:pa][:int].parent.should == root[:re][:pa]
        end

        it 'does not compress terminal nodes' do
          root.add_branch 'you'
          root.add_branch 'your'
          root.add_branch 'yours'

          root.compress!

          root[:you].letter.should == :you

          root[:you][:r].letter.should == :r
          root[:you][:r].should be_compressed

          root[:you][:r][:s].letter.should == :s
          root[:you][:r][:s].should be_compressed
        end

        describe 'and trying to add a branch' do
          it 'raises an error' do
            root.add_branch 'repay'
            root.add_branch 'rest'
            root.add_branch 'repaint'
            root.compress!

            lambda { root.add_branch('restaurant') }.should raise_error(InvalidOperation)
          end
        end
      end

      describe '#has_branch?' do
        context 'word is contained' do
          shared_examples_for 'word is found' do
            it 'matches part of the word' do
              root.should have_branch 'hell'
              root.should have_branch 'hig'
            end

            it 'matches the whole word' do
              root.word?('hello').should be_true
              root.word?('high').should be_true
            end
          end

          before :each do
            root.add_branch 'hello'
            root.add_branch 'high'
          end

          it_behaves_like 'word is found'

          context 'and the root been compressed' do
            before :each do
              root.compress!
            end

            it_behaves_like 'word is found'
          end
        end

        context 'word is not contained' do
          shared_examples_for 'word not found' do
            it 'does not match any part of the word' do
              root.should_not have_branch 'ha'
              root.should_not have_branch 'hal'
            end

            it 'does not match the whole word' do
              root.word?('halt').should be_false
            end
          end

          before :each do
            root.add_branch 'hello'
          end

          it_behaves_like 'word not found'

          context 'and the root has been compressed' do
            before :each do
              root.compress!
            end

            it_behaves_like 'word not found'
          end
        end
      end

      describe '#has_branch_for?' do
        let(:root) { Root.new }
        let(:word) { 'word' }

        before :each do
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
            root.has_branch_for?(word).should == value
          end
        end
      end

      describe '#is_word?' do
        let(:root) { Root.new }
        let(:word) { 'word' }

        before :each do
          root.stub(:warn)
          root.stub(:word?)
        end

        it 'warns about deprecation' do
          root.should_receive(:warn)
          root.is_word? word
        end

        it 'delegates to #word?' do
          [true, false].each do |value|
            root.should_receive(:word?).and_return value
            root.is_word?(word).should == value
          end
        end
      end

      describe '#include?' do
        let(:word) { 'word' }

        it 'delegates to #word?' do
          [true, false].each do |value|
            root.stub(:word?).with(word).and_return value
            root.include?(word).should &method("be_#{value}".to_sym)
          end
        end
      end

      describe '#add_branch' do
        let(:original_word) { 'word' }
        let(:word) { original_word.clone }

        it 'does not change the original word' do
          root.add_branch word
          word.should == original_word
        end

        it 'is still aliased as #<<' do
          root << word
          word.should == original_word
        end
      end
    end
  end
end
