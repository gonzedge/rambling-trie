require 'spec_helper'

describe Rambling::Trie::Compressor do
  let(:compressor) { Rambling::Trie::Compressor.new }

  describe '#compress' do
    let(:words) { %w(a few words hello hell) }
    let(:root) do
      Rambling::Trie::Nodes::Raw.new
    end

    before do
      words.each { |w| root.add w.clone }
    end

    it 'generates a new root with the words from the passed root' do
      new_root = compressor.compress root

      expect(words).not_to be_empty
      words.each do |word|
        expect(new_root).to include word
      end
    end

    it 'compresses the new root' do
      new_root = compressor.compress root

      expect(new_root.children_tree.keys).to eq %i(a few words hell)
    end
  end
end
