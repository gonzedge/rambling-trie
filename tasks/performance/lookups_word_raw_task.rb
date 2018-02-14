require_relative 'lookups_task'

module Performance
  class LookupsWordRawTask < Performance::LookupsTask
    def name
      'lookups:word:raw'
    end

    def execute reporter_class
      trie = raw_trie
      reporter = reporter_class.new filename

      reporter.report iterations, params do |word|
        trie.word? word
      end
    end

    private

    def params
      %w(hi help beautiful impressionism anthropological)
    end

    def filename
      'lookups-word-raw'
    end
  end
end
