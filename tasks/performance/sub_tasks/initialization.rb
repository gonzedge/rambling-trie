require_relative '../../helpers/path'

module Performance
  module SubTasks
    class Initialization
      include Helpers::Path

      def initialize iterations = 5
        @iterations = iterations
      end

      private

      attr_reader :iterations, :params
    end
  end
end
