module Helpers
  module Time
    def time
      @time ||= ::Time.now.to_i
    end
  end
end
