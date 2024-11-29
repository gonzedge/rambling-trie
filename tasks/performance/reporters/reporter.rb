# frozen_string_literal: true

require_relative '../../helpers/garbage_collection'
require_relative '../../helpers/path'
require_relative '../../helpers/time'
require_relative '../../helpers/trie'

module Performance
  module Reporters
    class Reporter
      include Helpers::GarbageCollection
      include Helpers::Path
      include Helpers::Time

      def report(iterations = 1, params = nil, &)
        params = Array params
        params << nil unless params.any?

        do_report(iterations, params, &)
      end
    end
  end
end
