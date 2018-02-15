require_relative '../lookup'

module Performance
  module SubTasks
    module Lookups
      module Word
        class Compressed < Performance::SubTasks::Lookups::Lookup
          def name
            'lookups:word:compressed'
          end

          def description
            'Lookups (compressed trie) - `word?`'
          end

          def execute reporter_class
            trie = compressed_trie
            reporter = reporter_class.new filename

            reporter.report iterations, params do |word|
              trie.word? word
            end
          end

          private

          def params
            %w(hi help beautiful impressionism anthropological)
          end
        end
      end
    end
  end
end
