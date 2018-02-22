# frozen_string_literal: true

module Rambling
  module Trie
    # Raised when trying to execute an invalid operation on a trie data
    # structure.
    class InvalidOperation < RuntimeError
      # Creates a new {InvalidOperation InvalidOperation} exception.
      # @param [String, nil] message the exception message.
      def initialize message = nil
        super
      end
    end
  end
end
