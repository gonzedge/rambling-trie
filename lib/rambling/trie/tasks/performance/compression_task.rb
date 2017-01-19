require_relative '../helpers/path'

module Performance
  class CompressionTask
    include Helpers::Path

    def initialize iterations = 5
      @iterations = iterations
    end

    def name
      'compression'
    end

    def execute reporter_class
      require 'rambling-trie'

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

    private

    attr_reader :iterations
  end
end
