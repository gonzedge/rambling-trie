# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Readers::Reader do
  subject(:reader) { described_class.new }

  describe '#load' do
    it 'is an abstract method that raises NotImplementedError' do
      expect { reader.each_word('any-file.zip') }
        .to raise_exception NotImplementedError
    end
  end
end
