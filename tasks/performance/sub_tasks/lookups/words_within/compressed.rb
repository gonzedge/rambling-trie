# frozen_string_literal: true

require_relative '../lookup'

module Performance
  module SubTasks
    module Lookups
      module WordsWithin
        class Compressed < Performance::SubTasks::Lookups::Lookup
          def initialize iterations = 100_000
            super iterations
          end

          def name
            'lookups:words_within:compressed'
          end

          def description
            'Lookups (compressed trie) - `words_within`'
          end

          def execute reporter_class
            trie = compressed_trie
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
