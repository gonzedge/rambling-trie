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
  module FlamegraphTasks
    include Helpers::Trie

    def flamegraph_tasks
      {
        'creation' => flamegraph_creation_task,
        'compression' => flamegraph_compression_task,
        'serialization:raw' => flamegraph_serialization_raw_task,
        'serialization:compressed' => flamegraph_serialization_compressed_task,
        'lookups:word:raw' => flamegraph_lookups_word_raw_task,
        'lookups:word:compressed' => flamegraph_lookups_word_compressed_task,
        'lookups:partial_word:raw' => flamegraph_lookups_partial_word_raw_task,
        'lookups:partial_word:compressed' => flamegraph_lookups_partial_word_compressed_task,
        'lookups:scan:raw' => flamegraph_lookups_scan_raw_task,
        'lookups:scan:compressed' => flamegraph_lookups_scan_compressed_task,
        'lookups:words_within:raw' => flamegraph_lookups_words_within_raw_task,
        'lookups:words_within:compressed' => flamegraph_lookups_words_within_compressed_task,
      }
    end

    private

    def flamegraph_task task
      lambda do |output|
        task.execute Performance::FlamegraphProfile
      end
    end

    def flamegraph_creation_task
      flamegraph_task Performance::CreationTask.new 1
    end

    def flamegraph_compression_task
      flamegraph_task Performance::CompressionTask.new 1
    end

    def flamegraph_serialization_raw_task
      flamegraph_task Performance::SerializationRawTask.new 1
    end

    def flamegraph_serialization_compressed_task
      flamegraph_task Performance::SerializationCompressedTask.new 1
    end

    def flamegraph_lookups_word_raw_task
      flamegraph_task Performance::LookupsWordRawTask.new 1
    end

    def flamegraph_lookups_partial_word_raw_task
      flamegraph_task Performance::LookupsPartialWordRawTask.new 1
    end

    def flamegraph_lookups_scan_raw_task
      flamegraph_task Performance::LookupsScanRawTask.new(
        hi: 1,
        help: 1,
        beautiful: 1,
        impressionism: 1,
        anthropological: 1,
      )
    end

    def flamegraph_lookups_words_within_raw_task
      flamegraph_task Performance::LookupsWordsWithinRawTask.new 1
    end

    def flamegraph_lookups_word_compressed_task
      flamegraph_task Performance::LookupsWordCompressedTask.new 1
    end

    def flamegraph_lookups_partial_word_compressed_task
      flamegraph_task Performance::LookupsPartialWordCompressedTask.new 1
    end

    def flamegraph_lookups_scan_compressed_task
      flamegraph_task Performance::LookupsScanCompressedTask.new(
        hi: 1,
        help: 1,
        beautiful: 1,
        impressionism: 1,
        anthropological: 1,
      )
    end

    def flamegraph_lookups_words_within_compressed_task
      flamegraph_task Performance::LookupsWordsWithinCompressedTask.new 1
    end
  end
end
