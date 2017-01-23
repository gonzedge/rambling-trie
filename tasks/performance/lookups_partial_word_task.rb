require_relative 'lookups_task'

module Performance
  class LookupsPartialWordTask < Performance::LookupsTask
    def name
      'lookups:partial_word'
    end

    def execute reporter_class, trie
      reporter = reporter_class.new filename trie
      reporter.report iterations, params do |word|
        trie.partial_word? word
      end
    end

    private

    def params
      %w(hi help beautiful impressionism anthropological)
    end

    def filename trie
      "#{trie.compressed? ? 'compressed' : 'raw'}-lookups-partial-word"
    end
  end
end
