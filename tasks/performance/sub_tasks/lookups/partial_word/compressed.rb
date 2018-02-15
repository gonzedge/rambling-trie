require_relative '../lookup'

module Performance
  module SubTasks
    module Lookups
      module PartialWord
        class Compressed < Performance::SubTasks::Lookups::Lookup
          def name
            'lookups:partial_word:compressed'
          end

          def description
            'Lookups (compressed trie) - `partial_word?`'
          end

          def execute reporter_class
            trie = compressed_trie
            reporter = reporter_class.new filename

            reporter.report iterations, params do |word|
              trie.partial_word? word
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
