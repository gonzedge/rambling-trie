module Performance
  class LookupsWordsWithinTask
    def initialize iterations = 100_000
      @iterations = iterations
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

    attr_reader :iterations

    def params
      %w(ifdxawesome45someword3 ifdx45someword3awesome)
    end

    def filename trie
      "#{trie.compressed? ? 'compressed' : 'raw'}-lookups-words-within"
    end
  end
end
