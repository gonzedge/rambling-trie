module Rambling
  module Trie
    # A representation of a missing node in the trie data structure. Returned
    # when a node is not found.
    class MissingNode < Rambling::Trie::Node
    end
  end
end
