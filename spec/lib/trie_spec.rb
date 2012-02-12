require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

module Rambling
  describe Trie do
    trie = nil

    after(:each) do
      trie = nil
    end

    describe 'when initializing a trie without filename' do
      before(:each) do
        trie = Trie.new
      end

      it 'should have no letter' do
        trie.letter.should be_nil
      end

      it 'should not be a terminal node' do
        trie.terminal?.should be_false
      end

      it 'should have no children' do
        trie.children.should be_empty
      end

      it 'should not be a word' do
        trie.is_word?.should be_false
      end
    end

    describe 'when initializing a trie from a file' do
      filename = File.join(File.dirname(__FILE__), '..', 'assets', 'test_words.txt')

      before(:each) do
        trie = Trie.new(filename)
      end

      it 'should add the expected root children' do
        File.open(filename) do |file|
          expected_hash = Hash[file.readlines.map { |x| [x.slice(0).to_sym, nil] }]
          trie.children.length.should == expected_hash.length
          trie.children.map { |k, v| k }.should =~ expected_hash.map { |k, v| k }
        end
      end

      it 'should load all words' do
        File.open(filename) do |file|
          file.readlines.each { |word| trie.is_word?(word.chomp).should be_true }
        end
      end

      describe 'and compressing it' do
        before(:each) do
          trie.compress!
        end

        it 'should mark the trie as compressed' do
          trie.compressed?.should be_true
        end

        it 'should compress the trie nodes' do
          trie[:t].letter.should == :t
          trie[:t].children.size.should == 2

          trie[:t][:ru].letter.should == :ru
          trie[:t][:ru].children.size.should == 2

          trie[:t][:ru][:e].terminal?.should be_true
          trie[:t][:ru][:e].compressed?.should be_true
        end
      end
    end

    describe 'when compressing a trie' do
      before(:each) do
        trie = Trie.new
      end

      it 'should return self after compressing marked as compressed' do
        compressed_trie = trie.compress!

        compressed_trie.should == trie
        compressed_trie.compressed?.should be_true
      end

      describe 'and trying to compress again' do
        it 'should keep returning self' do
          compressed_trie = trie.compress!.compress!

          compressed_trie.should == trie
          compressed_trie.compressed?.should be_true
        end
      end

      describe 'that has at least one word' do
        it 'should keep the trie letter nil' do
          trie.add_branch_from('all')
          trie.compress!

          trie.letter.should be_nil
        end
      end

      it 'should compress into a single node without children for a single word trie' do
        trie.add_branch_from('all')
        trie.compress!

        trie[:all].letter.should == :all
        trie[:all].children.should be_empty
        trie[:all].terminal?.should be_true
        trie[:all].compressed?.should be_true
      end

      it 'should compress into corresponding three nodes for a two word trie' do
        trie.add_branch_from('all')
        trie.add_branch_from('ask')
        trie.compress!

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

      it 'should assign the parent nodes correctly on compression' do
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

      it 'should not compress terminal nodes' do
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
        it 'should raise an exception' do
          trie.add_branch_from('repay')
          trie.add_branch_from('rest')
          trie.add_branch_from('repaint')
          trie.compress!

          lambda { trie.add_branch_from('restaurant') }.should raise_error(Rambling::InvalidTrieOperation)
        end
      end
    end

    describe 'when matching a word' do
      before(:each) do
        trie = Rambling::Trie.new
      end

      describe 'and it is contained in the trie' do
        before(:each) do
          trie.add_branch_from 'hello'
          trie.add_branch_from 'high'
        end

        it 'should find part of the word in the tree' do
          trie.has_branch_for?('hell').should be_true
          trie.has_branch_for?('hig').should be_true
        end

        it 'should find the word in the tree' do
          trie.is_word?('hello').should be_true
          trie.is_word?('high').should be_true
        end

        describe 'which has been compressed' do
          before(:each) do
            trie.compress!
          end

          it 'should find part of the word in the tree' do
            trie.has_branch_for?('hell').should be_true
            trie.has_branch_for?('hig').should be_true
          end

          it 'should find the word in the tree' do
            trie.is_word?('hello').should be_true
            trie.is_word?('high').should be_true
          end
        end
      end

      describe 'and it is not contained in the trie' do
        before(:each) do
          trie.add_branch_from 'hello'
        end

        it 'should not find any part of the word in the tree' do
          trie.has_branch_for?('ha').should be_false
          trie.has_branch_for?('hal').should be_false
        end

        it 'should not find the word in the tree' do
          trie.is_word?('halt').should be_false
        end

        describe 'which has been compressed' do
          before(:each) do
            trie.compress!
          end

          it 'should not find part of the word in the tree' do
            trie.has_branch_for?('ha').should be_false
            trie.has_branch_for?('hal').should be_false
          end

          it 'should not find the word in the tree' do
            trie.is_word?('halt').should be_false
          end
        end
      end
    end
  end
end
