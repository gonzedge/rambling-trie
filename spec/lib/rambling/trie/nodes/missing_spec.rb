# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Nodes::Missing do
  let(:node) { described_class.new }

  %i(partial_word? word?).each do |method|
    describe "##{method}" do
      it 'returns false for any chars' do
        expect(node.send(method, %w(a b))).to be false
      end

      it 'returns false for empty chars' do
        expect(node.send(method, [])).to be false
      end
    end
  end

  describe '#match_prefix' do
    it 'returns nothing' do
      expect(node.match_prefix(%(a b)).to_a).to be_empty
    end
  end

  describe '#each' do
    it 'yields nothing' do
      expect(node.to_a).to be_empty
    end
  end
end
