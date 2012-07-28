require 'spec_helper'

module Rambling
  module Trie
    describe ChildrenHashDeferer do
      class ClassWithChildren
        include ChildrenHashDeferer
        attr_accessor :children

        def initialize()
          @children = {}
        end
      end

      let(:deferer) { ClassWithChildren.new }

      describe '#[]' do
        let(:key) { :key }
        let(:value) { 'value' }

        it 'defers to the children hash' do
          deferer.children.should_receive(:[]).with(key).and_return value
          deferer[key].should == value
        end
      end

      describe '#[]=' do
        let(:key) { :key }
        let(:value) { 'value' }

        it 'defers to the children hash' do
          deferer.children.should_receive(:[]=).with(key, value)
          deferer[key] = value
        end
      end

      describe '#delete' do
        let(:key) { :key }
        let(:value) { 'value' }

        it 'defers to the children hash' do
          deferer.children.should_receive(:delete).with(key).and_return value
          deferer.delete(key).should == value
        end
      end

      describe '#has_key' do
        let(:key) { :key }

        it 'defers to the children hash' do
          [true, false].each do |value|
            deferer.children.should_receive(:has_key?).with(key).and_return value
            deferer.has_key?(key).should send("be_#{value}")
          end
        end
      end
    end
  end
end
