require_relative '../helpers/path'

module Performance
  class CreationTask
    include Helpers::Path

    def initialize iterations = 5
      @iterations = iterations
    end

    def name
      'creation'
    end

    def execute reporter_class
      reporter = reporter_class.new name
      reporter.report iterations, params do
        Rambling::Trie.create dictionary; nil
      end
    end

    private

    attr_reader :iterations, :params
  end
end
