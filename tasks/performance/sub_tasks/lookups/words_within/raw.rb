require_relative '../lookup'

module Performance
  module SubTasks
    module Lookups
      module WordsWithin
        class Raw < Performance::SubTasks::Lookups::Lookup
          def initialize iterations = 100_000
            super iterations
          end

          def name
            'lookups:words_within:raw'
          end

          def description
            'Lookups (raw trie) - `words_within`'
          end

          def execute reporter_class
            trie = raw_trie
            reporter = reporter_class.new filename

            reporter.report iterations, params do |word|
              trie.words_within(word).size
            end
          end

          private

          def params
            %w(ifdxawesome45someword3 ifdx45someword3awesome)
          end
        end
      end
    end
  end
end
