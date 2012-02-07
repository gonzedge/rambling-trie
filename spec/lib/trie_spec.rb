require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

module Rambling
  describe Trie do
    describe 'when initializing a trie without filename' do
      trie = nil

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
    end

    describe 'when initializing a trie from a file' do
      trie = nil
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
          file.readlines.each { |word| trie.has_branch_for?(word.chomp).should be_true }
        end
      end

      describe 'and compressing the trie' do
        before(:each) do
          trie.compress!
        end

        it 'should mark the trie as compressed' do
          trie.compressed?.should be_true
        end

        it 'should compress the trie nodes' do
          trie[:t][:ru].letter.should == :ru
          trie[:t][:ru].children.size.should == 2
          trie[:t][:ru][:e].terminal?.should be_true
        end
      end
    end
  end
end
