require 'spec_helper'

module Rambling
  module Trie
    describe Inspector do
      let(:root) do
        Root.new do |trie|
          %w(only three words).each { |word| trie << word }
        end
      end

      let(:node) { root[:o] }

      describe '#inspect' do
        it 'returns a pretty printed version of the node' do
          expect(root.inspect).to eq "#<Rambling::Trie::Root letter: nil, children: [:o, :t, :w]>"
          expect(node.inspect).to eq "#<Rambling::Trie::Node letter: :o, children: [:n]>"
        end
      end
    end
  end
end
