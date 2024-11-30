# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Nodes::Node do
  let(:node) { described_class.new }

  it_behaves_like 'a trie node'

  %i(children_match_prefix partial_word_chars? word_chars? closest_node).each do |abstract_method|
    it "does not implement #{abstract_method} (abstract private method)" do
      expect { node.send abstract_method, %w(o n e) }
        .to raise_error NotImplementedError
    end
  end
end
