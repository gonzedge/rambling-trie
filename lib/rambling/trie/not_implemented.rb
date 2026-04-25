# frozen_string_literal: true

module Rambling
  module Trie
    # Provides a private helper for marking abstract methods.
    # @api private
    module NotImplemented
      private

      # Raises {NotImplementedError} with the concrete class and calling method name.
      # @raise [NotImplementedError] always, with message
      #   <code>"ClassName#method_name is not implemented"</code>
      # @return [void]
      def not_implemented
        raise NotImplementedError,
          "#{self.class}##{caller_locations(1, 1)&.first&.label} is not implemented"
      end
    end

    private_constant :NotImplemented
  end
end
