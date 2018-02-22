# frozen_string_literal: true

module Helpers
  module Time
    def time
      Helpers::Time.time
    end

    def self.time
      @time ||= ::Time.now.strftime '%Y-%m-%d %H.%M.%S.%L'
    end
  end
end
