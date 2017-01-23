require_relative '../helpers/gc'
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
  module MemoryTasks
    include Helpers::GC
    include Helpers::Trie

    def memory_tasks
      {
        'creation' => memory_creation_task,
        'compression' => memory_compression_task,
        'serialization:raw' => memory_serialization_raw_task,
        'serialization:compressed' => memory_serialization_compressed_task,
        'lookups:word' => memory_lookups_word_task,
        'lookups:partial_word' => memory_lookups_partial_word_task,
        'lookups:scan' => memory_lookups_scan_task,
        'lookups:words_within' => memory_lookups_words_within_task,
      }
    end

    private

    def memory_task task
      lambda do |output|
        task.execute Performance::MemoryProfile
        yield if block_given?
      end
    end

    def memory_multiple_tries_task task
      lambda do |output|
        tries.each do |trie|
          task.execute Performance::MemoryProfile, trie
        end
      end
    end

    def memory_creation_task
      memory_task Performance::CreationTask.new 1
    end

    def memory_compression_task
      compression_task = Performance::CompressionTask.new 1
      memory_task compression_task do
        with_gc_stats 'garbage collection' do
          GC.start
        end
      end
    end

    def memory_serialization_raw_task
      memory_task Performance::SerializationRawTask.new 1
    end

    def memory_serialization_compressed_task
      memory_task Performance::SerializationCompressedTask.new 1
    end

    def memory_lookups_word_task
      memory_multiple_tries_task Performance::LookupsWordTask.new 10
    end

    def memory_lookups_partial_word_task
      memory_multiple_tries_task Performance::LookupsPartialWordTask.new 10
    end

    def memory_lookups_scan_task
      memory_multiple_tries_task Performance::LookupsScanTask.new(
        hi: 1,
        help: 100,
        beautiful: 100,
        impressionism: 200,
        anthropological: 200,
      )
    end

    def memory_lookups_words_within_task
      memory_multiple_tries_task Performance::LookupsWordsWithinTask.new 10
    end
  end
end
