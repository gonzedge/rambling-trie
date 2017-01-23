module Performance
  class LookupsTask
    def initialize iterations = 200_000
      @iterations = iterations
    end

    private

    attr_reader :iterations
  end
end
