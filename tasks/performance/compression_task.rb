require_relative 'initialization_task'

module Performance
  class CompressionTask < Performance::InitializationTask
    def name
      'compression'
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
