# frozen_string_literal: true

%w(node missing compressed raw).each do |file|
  require File.join('rambling', 'trie', 'nodes', file)
end

module Rambling
  module Trie
    # Namespace for all nodes.
    module Nodes
    end
  end
end
