require_relative 'initialization_task'

module Performance
  class SerializationCompressedTask < Performance::InitializationTask
    def name
      'serialization:compressed'
    end

    def execute reporter_class
      reporter = reporter_class.new name
      reporter.report iterations, params do
        Rambling::Trie.load compressed_trie_path; nil
      end
    end

    private

    def filename
      'serialization-compressed'
    end
  end
end
