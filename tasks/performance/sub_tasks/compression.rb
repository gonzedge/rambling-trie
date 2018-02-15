require_relative 'initialization'

module Performance
  module SubTasks
    class Compression < Performance::SubTasks::Initialization
      def name
        'compression'
      end

      def description
        'Compression - `compress!`'
      end

      def execute reporter_class
        reporter = reporter_class.new name

        tries = []
        iterations.times { tries << Rambling::Trie.load(raw_trie_path) }

        i = 0
        reporter.report iterations do |trie|
          tries[i].compress!
          i += 1
          nil
        end

        yield if block_given?
      end
    end
  end
end
