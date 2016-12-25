module Helpers
  module Time
    def time
      @time ||= ::Time.now.strftime '%Y-%m-%d %H.%M.%S.%L'
    end
  end
end
