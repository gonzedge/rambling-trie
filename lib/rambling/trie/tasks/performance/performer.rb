require_relative '../helpers/gc'
require_relative '../helpers/path'
require_relative '../helpers/time'
require_relative '../helpers/trie'

module Performance
  class Performer
    include Helpers::GC
    include Helpers::Path
    include Helpers::Time

    def perform iterations = 1, params = nil
      params = Array params
      params << nil unless params.any?

      do_perform iterations, params do |param|
        yield param
      end
    end
  end
end
