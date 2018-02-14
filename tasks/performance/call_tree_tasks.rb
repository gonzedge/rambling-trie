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
  module CallTreeTasks
    include Helpers::Trie

    def call_tree_tasks
      {
        'creation' => call_tree_creation_task,
        'compression' => call_tree_compression_task,
        'serialization:raw' => call_tree_serialization_raw_task,
        'serialization:compressed' => call_tree_serialization_compressed_task,
        'lookups:word:raw' => call_tree_lookups_word_raw_task,
        'lookups:word:compressed' => call_tree_lookups_word_compressed_task,
        'lookups:partial_word:raw' => call_tree_lookups_partial_word_raw_task,
        'lookups:partial_word:compressed' => call_tree_lookups_partial_word_compressed_task,
        'lookups:scan:raw' => call_tree_lookups_scan_raw_task,
        'lookups:scan:compressed' => call_tree_lookups_scan_compressed_task,
        'lookups:words_within:raw' => call_tree_lookups_words_within_raw_task,
        'lookups:words_within:compressed' => call_tree_lookups_words_within_compressed_task,
      }
    end

    private

    def call_tree_task task
      lambda do |output|
        task.execute Performance::CallTreeProfile
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

    def call_tree_lookups_word_raw_task
      call_tree_task Performance::LookupsWordRawTask.new
    end

    def call_tree_lookups_word_compressed_task
      call_tree_task Performance::LookupsWordCompressedTask.new
    end

    def call_tree_lookups_partial_word_raw_task
      call_tree_task Performance::LookupsPartialWordRawTask.new
    end

    def call_tree_lookups_partial_word_compressed_task
      call_tree_task Performance::LookupsPartialWordCompressedTask.new
    end

    def call_tree_lookups_scan_raw_task
      call_tree_task Performance::LookupsScanRawTask.new
    end

    def call_tree_lookups_scan_compressed_task
      call_tree_task Performance::LookupsScanCompressedTask.new
    end

    def call_tree_lookups_words_within_raw_task
      call_tree_task Performance::LookupsWordsWithinRawTask.new
    end

    def call_tree_lookups_words_within_compressed_task
      call_tree_task Performance::LookupsWordsWithinCompressedTask.new
    end
  end
end
