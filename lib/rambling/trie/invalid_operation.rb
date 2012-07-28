module Rambling
  module Trie
    # Raised when trying to execute an invalid operation for this Trie data structure.
    class InvalidOperation < Exception
      def initialize(message = nil)
        super
      end
    end
  end
end
