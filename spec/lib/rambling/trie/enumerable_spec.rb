require 'spec_helper'

module Rambling
  module Trie
    describe Enumerable do
      let(:root) { Root.new }
      let(:words) { %w(add some words and another word) }

      before :each do
        words.each { |word| root << word.clone }
      end

      describe '#each' do
        it 'returns an enumerator' do
          root.each.should be_a(Enumerator)
        end

        it 'includes every word contained in the trie' do
          root.each { |word| words.should include(word) }
          root.count.should == words.count
        end
      end

      describe '#size' do
        it 'delegates to #count' do
          root.size.should == words.size
        end
      end

      it 'includes the core Enumerable module' do
        root.all? { |word| words.include? word }.should be_true
        root.any? { |word| word.start_with? 's' }.should be_true
        root.to_a.should =~ words
      end
    end
  end
end
