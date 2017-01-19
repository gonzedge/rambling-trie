require_relative '../helpers/path'

module Performance
  class SerializationCompressedTask
    include Helpers::Path

    def initialize iterations = 5
      @iterations = iterations
    end

    def name
      'serialization:compressed'
    end

    def execute reporter_class
      require 'rambling-trie'

      reporter = reporter_class.new name
      reporter.report iterations, params do
        Rambling::Trie.load compressed_trie_path; nil
      end
    end

    private

    attr_reader :iterations, :params

    def filename
      'serialization-compressed'
    end
  end
end
