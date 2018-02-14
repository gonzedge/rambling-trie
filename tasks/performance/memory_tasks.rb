require_relative '../helpers/gc'
require_relative '../helpers/trie'

%w{
  compression_task creation_task lookups_partial_word_raw_task
  lookups_partial_word_compressed_task lookups_scan_raw_task
  lookups_scan_compressed_task lookups_word_raw_task
  lookups_word_compressed_task lookups_words_within_raw_task
  lookups_words_within_compressed_task serialization_compressed_task
  serialization_raw_task
}.each do |task|
  require_relative task
end

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
        'lookups:word:raw' => memory_lookups_word_raw_task,
        'lookups:word:compressed' => memory_lookups_word_compressed_task,
        'lookups:partial_word:raw' => memory_lookups_partial_word_raw_task,
        'lookups:partial_word:compressed' => memory_lookups_partial_word_compressed_task,
        'lookups:scan:raw' => memory_lookups_scan_raw_task,
        'lookups:scan:compressed' => memory_lookups_scan_compressed_task,
        'lookups:words_within:raw' => memory_lookups_words_within_raw_task,
        'lookups:words_within:compressed' => memory_lookups_words_within_compressed_task,
      }
    end

    private

    def memory_task task
      lambda do |output|
        task.execute Performance::MemoryProfile
        yield if block_given?
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

    def memory_lookups_word_raw_task
      memory_task Performance::LookupsWordRawTask.new 10
    end

    def memory_lookups_word_compressed_task
      memory_task Performance::LookupsWordCompressedTask.new 10
    end

    def memory_lookups_partial_word_raw_task
      memory_task Performance::LookupsPartialWordRawTask.new 10
    end

    def memory_lookups_partial_word_compressed_task
      memory_task Performance::LookupsPartialWordCompressedTask.new 10
    end

    def memory_lookups_scan_raw_task
      memory_task Performance::LookupsScanRawTask.new(
        hi: 1,
        help: 100,
        beautiful: 100,
        impressionism: 200,
        anthropological: 200,
      )
    end

    def memory_lookups_scan_compressed_task
      memory_task Performance::LookupsScanCompressedTask.new(
        hi: 1,
        help: 100,
        beautiful: 100,
        impressionism: 200,
        anthropological: 200,
      )
    end

    def memory_lookups_words_within_raw_task
      memory_task Performance::LookupsWordsWithinRawTask.new 10
    end

    def memory_lookups_words_within_compressed_task
      memory_task Performance::LookupsWordsWithinCompressedTask.new 10
    end
  end
end
