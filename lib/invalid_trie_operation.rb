module Rambling
  # Raised when trying to execute an invalid operation for this Trie data structure.
  class InvalidTrieOperation < Exception
    def initialize(message = nil)
      super
    end
  end
end
