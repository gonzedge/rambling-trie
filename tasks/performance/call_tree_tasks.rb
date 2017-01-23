require_relative '../helpers/trie'
require_relative 'compression_task'
require_relative 'creation_task'
require_relative 'lookups_partial_word_task'
require_relative 'lookups_scan_task'
require_relative 'lookups_word_task'
require_relative 'lookups_words_within_task'
require_relative 'serialization_compressed_task'
require_relative 'serialization_raw_task'

module Performance
  module CallTreeTasks
    include Helpers::Trie

    def call_tree_tasks
      {
        'creation' => call_tree_creation_task,
        'compression' => call_tree_compression_task,
        'serialization:raw' => call_tree_serialization_raw_task,
        'serialization:compressed' => call_tree_serialization_compressed_task,
        'lookups:word' => call_tree_lookups_word_task,
        'lookups:partial_word' => call_tree_lookups_partial_word_task,
        'lookups:scan' => call_tree_lookups_scan_task,
        'lookups:words_within' => call_tree_lookups_words_within_task,
      }
    end

    private

    def call_tree_task task
      lambda do |output|
        task.execute Performance::CallTreeProfile
      end
    end

    def call_tree_multiple_tries_task task
      lambda do |output|
        tries.each do |trie|
          task.execute Performance::CallTreeProfile, trie
        end
      end
    end

    def call_tree_creation_task
      call_tree_task Performance::CreationTask.new
    end

    def call_tree_compression_task
      call_tree_task Performance::CompressionTask.new
    end

    def call_tree_serialization_raw_task
      call_tree_task Performance::SerializationRawTask.new
    end

    def call_tree_serialization_compressed_task
      call_tree_task Performance::SerializationCompressedTask.new
    end

    def call_tree_lookups_word_task
      call_tree_multiple_tries_task Performance::LookupsWordTask.new
    end

    def call_tree_lookups_partial_word_task
      call_tree_multiple_tries_task Performance::LookupsPartialWordTask.new
    end

    def call_tree_lookups_scan_task
      call_tree_multiple_tries_task Performance::LookupsScanTask.new
    end

    def call_tree_lookups_words_within_task
      call_tree_multiple_tries_task Performance::LookupsWordsWithinTask.new
    end
  end
end
