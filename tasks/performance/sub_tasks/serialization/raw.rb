require_relative '../initialization'

module Performance
  module SubTasks
    module Serialization
      class Raw < Performance::SubTasks::Initialization
        def name
          'serialization:raw'
        end

        def description
          'Serialization (raw trie) - `Rambling::Trie.load`'
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
  end
end
