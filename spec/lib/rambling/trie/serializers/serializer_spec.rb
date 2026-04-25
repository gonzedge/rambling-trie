# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Serializers::Serializer do
  subject(:serializer) { described_class.new }

  describe '#load' do
    it 'is an abstract method that raises NotImplementedError with class and method name' do
      expect { serializer.load('any-file.zip') }
        .to raise_error NotImplementedError, /#{described_class}#load is not implemented/
    end
  end

  describe '#dump' do
    it 'is an abstract method that raises NotImplementedError with class and method name' do
      expect { serializer.dump('any contents', 'any-file.zip') }
        .to raise_error NotImplementedError, /#{described_class}#dump is not implemented/
    end
  end
end
