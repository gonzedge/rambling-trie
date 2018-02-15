require_relative 'initialization'

module Performance
  module SubTasks
    class Creation < Performance::SubTasks::Initialization
      def name
        'creation'
      end

      def description
        'Creation - `Rambling::Trie.create`'
      end

      def execute reporter_class
        reporter = reporter_class.new name
        reporter.report iterations, params do
          Rambling::Trie.create dictionary; nil
        end
      end
    end
  end
end
