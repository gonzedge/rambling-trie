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

    def call_tree_lookups_scan_task
      lambda do |output|
        task = Performance::LookupsScanTask.new
        tries.each do |trie|
          task.execute Performance::CallTreeProfile, trie
        end
      end
    end

    def call_tree_lookups_words_within_task
      lambda do |output|
        task = Performance::LookupsWordsWithinTask.new
        tries.each do |trie|
          task.execute Performance::CallTreeProfile, trie
        end
      end
    end

    def call_tree_lookups_partial_word_task
      lambda do |output|
        task = Performance::LookupsPartialWordTask.new
        tries.each do |trie|
          task.execute Performance::CallTreeProfile, trie
        end
      end
    end

    def call_tree_lookups_word_task
      lambda do |output|
        task = Performance::LookupsWordTask.new
        tries.each do |trie|
          task.execute Performance::CallTreeProfile, trie
        end
      end
    end

    def call_tree_serialization_compressed_task
      lambda do |output|
        task = Performance::SerializationCompressedTask.new
        task.execute Performance::CallTreeProfile
      end
    end

    def call_tree_serialization_raw_task
      lambda do |output|
        task = Performance::SerializationRawTask.new
        task.execute Performance::CallTreeProfile
      end
    end

    def call_tree_compression_task
      lambda do |output|
        task = Performance::CompressionTask.new
        task.execute Performance::CallTreeProfile
      end
    end

    def call_tree_creation_task
      lambda do |output|
        task = Performance::CreationTask.new
        task.execute Performance::CallTreeProfile
      end
    end
  end
end
