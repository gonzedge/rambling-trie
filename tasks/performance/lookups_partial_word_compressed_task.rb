require_relative 'lookups_task'

module Performance
  class LookupsPartialWordCompressedTask < Performance::LookupsTask
    def name
      'lookups:partial_word:compressed'
    end

    def execute reporter_class
      trie = compressed_trie
      reporter = reporter_class.new filename

      reporter.report iterations, params do |word|
        trie.partial_word? word
      end
    end

    private

    def params
      %w(hi help beautiful impressionism anthropological)
    end

    def filename
      'lookups-partial-word-compressed'
    end
  end
end
