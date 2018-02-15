module Performance
  module SubTasks
    class SubTask
      def filename
        name.gsub /:|_/, '-'
      end
    end
  end
end
