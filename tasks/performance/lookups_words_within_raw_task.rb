require_relative 'lookups_task'

module Performance
  class LookupsWordsWithinRawTask < Performance::LookupsTask
    def initialize iterations = 100_000
      super iterations
    end

    def name
      'lookups:words_within:raw'
    end

    def execute reporter_class
      trie = raw_trie
      reporter = reporter_class.new filename

      reporter.report iterations, params do |word|
        trie.words_within(word).size
      end
    end

    private

    def params
      %w(ifdxawesome45someword3 ifdx45someword3awesome)
    end

    def filename
      'lookups-words-within-raw'
    end
  end
end
