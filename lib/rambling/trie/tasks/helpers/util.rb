module Helpers
  module Util
    def performance_report= performance_report
      @performance_report = performance_report
    end

    def performance_report
      @performance_report ||= PerformanceReport.new
    end

    def output
      performance_report.output
    end

    def tries
      [
        Rambling::Trie.load(raw_trie_path),
        Rambling::Trie.load(compressed_trie_path)
      ]
    end
  end
end
