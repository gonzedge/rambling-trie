# frozen_string_literal: true

path = File.join 'rambling', 'trie', 'nodes'
%w(node missing compressed raw).each do |file|
  require File.join(path, file)
end

module Rambling
  module Trie
    # Namespace for all nodes.
    module Nodes
    end
  end
end
