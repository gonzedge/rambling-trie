require_relative '../helpers/trie'

module Performance
  class LookupsTask
    include Helpers::Trie

    def initialize iterations = 200_000
      @iterations = iterations
    end

    private

    attr_reader :iterations
  end
end
