require_relative '../helpers/path'

module Performance
  class SerializationRawTask
    include Helpers::Path

    def initialize iterations = 5
      @iterations = iterations
    end

    def name
      'serialization:raw'
    end

    def execute performer_class
      performer = performer_class.new filename
      performer.perform iterations, params do
        Rambling::Trie.load raw_trie_path; nil
      end
    end

    private

    attr_reader :iterations, :params

    def filename
      'serialization-raw'
    end
  end
end
