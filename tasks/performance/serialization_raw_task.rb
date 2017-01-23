require_relative 'initialization_task'

module Performance
  class SerializationRawTask < Performance::InitializationTask
    def name
      'serialization:raw'
    end

    def execute reporter_class
      reporter = reporter_class.new filename
      reporter.report iterations, params do
        Rambling::Trie.load raw_trie_path; nil
      end
    end

    private

    def filename
      'serialization-raw'
    end
  end
end
