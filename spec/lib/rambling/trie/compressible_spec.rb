# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Compressible do
  describe '#compressible?' do
    context 'with a raw node' do
      let(:node) { Rambling::Trie::Nodes::Raw.new }

      context 'when the node has one non-terminal child' do
        before { add_word node, 'ab' }

        it 'returns true for the single-child node' do
          expect(node[:a]).to be_compressible
        end
      end

      context 'when the node has more than one child' do
        before { add_words node, %w(ab ac) }

        it 'returns false' do
          expect(node[:a]).not_to be_compressible
        end
      end

      context 'when the node is terminal' do
        before { add_word node, 'a' }

        it 'returns false' do
          expect(node[:a]).not_to be_compressible
        end
      end

      context 'when the node is root' do
        it 'returns false' do
          expect(node).not_to be_compressible
        end
      end
    end

    context 'with a compressed node' do
      let(:raw_node) { Rambling::Trie::Nodes::Raw.new }
      let(:compressor) { Rambling::Trie::Compressor.new }

      context 'when the node has single terminal compressed child' do
        before { add_word raw_node, 'ab' }

        let(:node) { compressor.compress raw_node }

        it 'returns false' do
          expect(node[:a]).not_to be_compressible
        end
      end

      context 'when the node has many children causing effectively no compression' do
        before { add_words raw_node, %w(ab ac) }

        let(:node) { compressor.compress raw_node }

        it 'returns false' do
          expect(node[:a]).not_to be_compressible
        end
      end

      context 'when the node is root' do
        let(:node) { compressor.compress raw_node }

        it 'returns false' do
          expect(node).not_to be_compressible
        end
      end
    end

    context 'with a compressed node in an in-between state' do
      let(:node) { Rambling::Trie::Nodes::Compressed.new }
      let(:in_between_child) { Rambling::Trie::Nodes::Compressed.new :hel, node }

      before { node[:h] = in_between_child }

      context 'when there is only one child and it is terminal' do
        let(:hello_child) { Rambling::Trie::Nodes::Compressed.new :lo, in_between_child }

        before { in_between_child[:l] = hello_child }

        it 'returns true for the in-between child' do
          expect(node[:h]).to be_compressible
        end

        it 'returns false for the terminal child' do
          expect(node[:h][:l]).not_to be_compressible
        end
      end

      context 'when there are multiple terminal children' do
        let(:hello_child) { Rambling::Trie::Nodes::Compressed.new :lo, in_between_child }
        let(:help_child) { Rambling::Trie::Nodes::Compressed.new :p, in_between_child }

        before do
          in_between_child[:l] = hello_child
          in_between_child[:p] = help_child
        end

        it 'returns false for the in-between child' do
          expect(node[:h]).not_to be_compressible
        end

        %i(l p).each do |letter|
          it "returns false for the terminal node #{letter}" do
            expect(node[:h][letter]).not_to be_compressible
          end
        end
      end

      context 'when the node is root' do
        it 'returns false' do
          expect(node).not_to be_compressible
        end
      end
    end
  end
end
