module Rambling
  module Trie
    # Raised when trying to execute an invalid operation on a Trie data
    # structure.
    class InvalidOperation < Exception
      # Creates a new {InvalidOperation InvalidOperation} exception.
      # @param [String, nil] message the exception message.
      def initialize message = nil
        super
      end
    end
  end
end
