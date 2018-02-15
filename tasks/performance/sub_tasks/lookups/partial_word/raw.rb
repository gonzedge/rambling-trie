require_relative '../lookup'

module Performance
  module SubTasks
    module Lookups
      module PartialWord
        class Raw < Performance::SubTasks::Lookups::Lookup
          def name
            'lookups:partial_word:raw'
          end

          def description
            'Lookups (raw trie) - `partial_word?`'
          end

          def execute reporter_class
            trie = raw_trie
            reporter = reporter_class.new filename

            reporter.report iterations, params do |word|
              trie.partial_word? word
            end
          end

          private

          def params
            %w(hi help beautiful impressionism anthropological)
          end

          def filename
            'lookups-partial-word-raw'
          end
        end
      end
    end
  end
end
