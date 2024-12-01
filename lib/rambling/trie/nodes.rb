# frozen_string_literal: true

path = File.join 'rambling', 'trie', 'nodes'
%w(node missing compressed raw).each { |file| require File.join(path, file) }

module Rambling
  module Trie
    # Namespace for all nodes.
    module Nodes
    end
  end
end
