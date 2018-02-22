# frozen_string_literal: true

module Support
  module Helpers
    module OneLineHeredoc
      def one_line heredoc
        heredoc.strip.tr "\n", ' '
      end
    end
  end
end
