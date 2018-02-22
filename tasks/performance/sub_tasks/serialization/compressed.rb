# frozen_string_literal: true

require_relative '../initialization'

module Performance
  module SubTasks
    module Serialization
      class Compressed < Performance::SubTasks::Initialization
        def name
          'serialization:compressed'
        end

        def description
          'Serialization (compressed trie) - `Rambling::Trie.load`'
        end

        def execute reporter_class
          reporter = reporter_class.new filename
          reporter.report iterations, params do
            Rambling::Trie.load compressed_trie_path
            nil
          end
        end
      end
    end
  end
end
