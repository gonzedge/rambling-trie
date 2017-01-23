require_relative 'lookups_task'

module Performance
  class LookupsWordsWithinTask < Performance::LookupsTask
    def initialize iterations = 100_000
      super iterations
    end

    def name
      'lookups:words_within'
    end

    def execute reporter_class, trie
      reporter = reporter_class.new filename trie
      reporter.report iterations, params do |word|
        trie.words_within(word).size
      end
    end

    private

    def params
      %w(ifdxawesome45someword3 ifdx45someword3awesome)
    end

    def filename trie
      "#{trie.compressed? ? 'compressed' : 'raw'}-lookups-words-within"
    end
  end
end
