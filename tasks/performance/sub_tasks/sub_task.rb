# frozen_string_literal: true

module Performance
  module SubTasks
    class SubTask
      def filename
        name.gsub %r{:|_/}, '-'
      end
    end
  end
end
