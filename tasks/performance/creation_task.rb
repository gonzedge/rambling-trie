require_relative 'initialization_task'

module Performance
  class CreationTask < Performance::InitializationTask
    def name
      'creation'
    end

    def execute reporter_class
      reporter = reporter_class.new name
      reporter.report iterations, params do
        Rambling::Trie.create dictionary; nil
      end
    end
  end
end
