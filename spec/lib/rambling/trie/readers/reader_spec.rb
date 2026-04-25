# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Readers::Reader do
  subject(:reader) { described_class.new }

  describe '#each_word' do
    it 'is an abstract method that raises NotImplementedError with class and method name' do
      expect { reader.each_word('any-file.zip') }
        .to raise_error NotImplementedError, /#{described_class}#each_word is not implemented/
    end
  end
end
