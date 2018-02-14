require_relative '../helpers/trie'

module Performance
  class LookupsScanRawTask
    include Helpers::Trie

    def initialize params_to_iterations = default_params
      @params_to_iterations = params_to_iterations
    end

    def name
      'lookups:scan:raw'
    end

    def execute reporter_class
      trie = raw_trie
      reporter = reporter_class.new filename

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

    def filename
      'lookups-scan-raw'
    end
  end
end
