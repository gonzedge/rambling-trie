require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

module Rambling
  describe Trie do
    context 'initialized without filename' do
      let(:trie) { Trie.new }

      it 'has no letter' do
        trie.letter.should be_nil
      end

      it 'is not a terminal node' do
        trie.terminal?.should be_false
      end

      it 'has no children' do
        trie.children.should be_empty
      end

      it 'is not a word' do
        trie.is_word?.should be_false
      end
    end

    context 'initialized from a file' do
      filename = File.join(File.dirname(__FILE__), '..', 'assets', 'test_words.txt')
      let(:trie) { Trie.new filename }

      it 'has the expected root children' do
        File.open(filename) do |file|
          expected_hash = Hash[file.readlines.map { |x| [x.slice(0).to_sym, nil] }]
          trie.children.length.should == expected_hash.length
          trie.children.map { |k, v| k }.should =~ expected_hash.map { |k, v| k }
        end
      end

      it 'loads every word' do
        File.open(filename) do |file|
          file.readlines.each { |word| trie.is_word?(word.chomp).should be_true }
        end
      end

      context 'and gets compressed' do
        before :each do
          trie.compress!
        end

        it 'is marked as compressed' do
          trie.compressed?.should be_true
        end

        it 'compresses the trie nodes' do
          trie[:t].letter.should == :t
          trie[:t].children.size.should == 2

          trie[:t][:ru].letter.should == :ru
          trie[:t][:ru].children.size.should == 2

          trie[:t][:ru][:e].terminal?.should be_true
          trie[:t][:ru][:e].compressed?.should be_true
        end
      end
    end

    describe '#compress!' do
      let(:trie) { Trie.new }

      it 'returns itself marked as compressed' do
        compressed_trie = trie.compress!

        compressed_trie.should == trie
        compressed_trie.compressed?.should be_true
      end

      context 'after calling #compress! once' do
        it 'keeps returning itself' do
          compressed_trie = trie.compress!.compress!

          compressed_trie.should == trie
          compressed_trie.compressed?.should be_true
        end
      end

      context 'with at least one word' do
        it 'keeps the trie letter nil' do
          trie.add_branch_from('all')
          trie.compress!

          trie.letter.should be_nil
        end
      end

      context 'with a single word' do
        before :each do
          trie.add_branch_from('all')
          trie.compress!
        end

        it 'compresses into a single node without children' do
          trie[:all].letter.should == :all
          trie[:all].children.should be_empty
          trie[:all].terminal?.should be_true
          trie[:all].compressed?.should be_true
        end
      end

      context 'with two words' do
        before :each do
          trie.add_branch_from('all')
          trie.add_branch_from('ask')
          trie.compress!
        end

        it 'compresses into corresponding three nodes' do
          trie[:a].letter.should == :a
          trie[:a].children.size.should == 2

          trie[:a][:ll].letter.should == :ll
          trie[:a][:sk].letter.should == :sk

          trie[:a][:ll].children.should be_empty
          trie[:a][:sk].children.should be_empty

          trie[:a][:ll].terminal?.should be_true
          trie[:a][:sk].terminal?.should be_true

          trie[:a][:ll].compressed?.should be_true
          trie[:a][:sk].compressed?.should be_true
        end
      end

      it 'reassigns the parent nodes correctly' do
        trie.add_branch_from('repay')
        trie.add_branch_from('rest')
        trie.add_branch_from('repaint')
        trie.compress!

        trie[:re].letter.should == :re
        trie[:re].children.size.should == 2

        trie[:re][:pa].letter.should == :pa
        trie[:re][:st].letter.should == :st

        trie[:re][:pa].children.size.should == 2
        trie[:re][:st].children.should be_empty

        trie[:re][:pa][:y].letter.should == :y
        trie[:re][:pa][:int].letter.should == :int

        trie[:re][:pa][:y].children.should be_empty
        trie[:re][:pa][:int].children.should be_empty

        trie[:re][:pa][:y].parent.should == trie[:re][:pa]
        trie[:re][:pa][:int].parent.should == trie[:re][:pa]
      end

      it 'does not compress terminal nodes' do
        trie.add_branch_from('you')
        trie.add_branch_from('your')
        trie.add_branch_from('yours')

        trie.compress!

        trie[:you].letter.should == :you

        trie[:you][:r].letter.should == :r
        trie[:you][:r].compressed?.should be_true

        trie[:you][:r][:s].letter.should == :s
        trie[:you][:r][:s].compressed?.should be_true
      end

      describe 'and trying to add a branch' do
        it 'raises an error' do
          trie.add_branch_from('repay')
          trie.add_branch_from('rest')
          trie.add_branch_from('repaint')
          trie.compress!

          lambda { trie.add_branch_from('restaurant') }.should raise_error(Rambling::InvalidTrieOperation)
        end
      end
    end

    describe '#has_branch_for?' do
      let(:trie) { Trie.new }

      context 'word is contained' do
        before :each do
          trie.add_branch_from 'hello'
          trie.add_branch_from 'high'
        end

        it 'matches part of the word' do
          trie.has_branch_for?('hell').should be_true
          trie.has_branch_for?('hig').should be_true
        end

        it 'matches the whole word' do
          trie.is_word?('hello').should be_true
          trie.is_word?('high').should be_true
        end

        context 'and the trie been compressed' do
          before :each do
            trie.compress!
          end

          it 'matches part of the word' do
            trie.has_branch_for?('hell').should be_true
            trie.has_branch_for?('hig').should be_true
          end

          it 'matches the whole word' do
            trie.is_word?('hello').should be_true
            trie.is_word?('high').should be_true
          end
        end
      end

      context 'word is not contained' do
        before :each do
          trie.add_branch_from 'hello'
        end

        it 'does not match any part of the word' do
          trie.has_branch_for?('ha').should be_false
          trie.has_branch_for?('hal').should be_false
        end

        it 'does not match the whole word' do
          trie.is_word?('halt').should be_false
        end

        context 'and the trie has been compressed' do
          before :each do
            trie.compress!
          end

          it 'does not match part of the word' do
            trie.has_branch_for?('ha').should be_false
            trie.has_branch_for?('hal').should be_false
          end

          it 'does not match the whole word' do
            trie.is_word?('halt').should be_false
          end
        end
      end
    end
  end
end
