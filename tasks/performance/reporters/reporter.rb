# frozen_string_literal: true

require_relative '../../helpers/gc'
require_relative '../../helpers/path'
require_relative '../../helpers/time'
require_relative '../../helpers/trie'

module Performance
  module Reporters
    class Reporter
      include Helpers::GC
      include Helpers::Path
      include Helpers::Time

      def report iterations = 1, params = nil, &block
        params = Array params
        params << nil unless params.any?

        do_report iterations, params, &block
      end
    end
  end
end
