module Performance
  class LookupsScanTask
    def initialize params_to_iterations = default_params
      @params_to_iterations = params_to_iterations
    end

    def name
      'lookups:scan'
    end

    def execute reporter_class, trie
      reporter = reporter_class.new filename trie
      params_to_iterations.each do |word, iterations|
        reporter.report iterations, word.to_s do |word|
          trie.scan(word).size
        end
      end
    end

    private

    attr_reader :params_to_iterations

    def default_params
      {
        hi: 1_000,
        help: 100_000,
        beautiful: 100_000,
        impressionism: 200_000,
        anthropological: 200_000,
      }
    end

    def filename trie
      "#{trie.compressed? ? 'compressed' : 'raw'}-lookups-scan"
    end
  end
end
