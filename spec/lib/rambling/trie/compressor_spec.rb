require 'spec_helper'

describe Rambling::Trie::Compressor do
  let(:compressor) { Rambling::Trie::Compressor.new }

  describe '#compress' do
    let(:new_root) { double :new_root, add: nil, compress!: nil }
    let(:words) { %w(a few words) }
    let(:root) { words }

    before do
      allow(Rambling::Trie::Root).to receive(:new)
        .and_return new_root
    end

    it 'generates a new root with the words from the passed root' do
      compressor.compress root

      expect(words).not_to be_empty
      words.each do |word|
        expect(new_root).to have_received(:add)
          .with('a')
      end
    end

    it 'compresses the new root' do
      compressor.compress root

      expect(new_root).to have_received :compress!
    end
  end
end
