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
  module BenchmarkTasks
    include Helpers::Trie

    def benchmark_tasks
      {
        'creation' => benchmark_creation_task,
        'compression' => benchmark_compression_task,
        'serialization:raw' => benchmark_serialization_raw_task,
        'serialization:compressed' => benchmark_serialization_compressed_task,
        'lookups:word:raw' => benchmark_lookups_word_raw_task,
        'lookups:word:compressed' => benchmark_lookups_word_compressed_task,
        'lookups:partial_word:raw' => benchmark_lookups_partial_word_raw_task,
        'lookups:partial_word:compressed' => benchmark_lookups_partial_word_compressed_task,
        'lookups:scan:raw' => benchmark_lookups_scan_raw_task,
        'lookups:scan:compressed' => benchmark_lookups_scan_compressed_task,
        'lookups:words_within:raw' => benchmark_lookups_words_within_raw_task,
        'lookups:words_within:compressed' => benchmark_lookups_words_within_compressed_task,
      }
    end

    private

    def banner output, title
      output.puts
      output.puts "==> #{title}"
    end

    def benchmark_task title, task
      lambda do |output|
        banner output, title
        task.execute Performance::Benchmark
      end
    end

    def benchmark_creation_task
      benchmark_task(
        'Creation - `Rambling::Trie.create`',
        Performance::CreationTask.new,
      )
    end

    def benchmark_compression_task
      benchmark_task(
        'Compression - `compress!`',
        Performance::CompressionTask.new,
      )
    end

    def benchmark_serialization_raw_task
      benchmark_task(
        'Serialization (raw trie) - `Rambling::Trie.load`',
        Performance::SerializationRawTask.new,
      )
    end

    def benchmark_serialization_compressed_task
      benchmark_task(
        'Serialization (compressed trie) - `Rambling::Trie.load`',
        Performance::SerializationCompressedTask.new,
      )
    end

    def benchmark_lookups_word_raw_task
      benchmark_task(
        'Lookups (raw trie) - `word?`',
        Performance::LookupsWordRawTask.new,
      )
    end

    def benchmark_lookups_word_compressed_task
      benchmark_task(
        'Lookups (compressed trie) - `word?`',
        Performance::LookupsWordCompressedTask.new,
      )
    end

    def benchmark_lookups_partial_word_raw_task
      benchmark_task(
        'Lookups (raw trie) - `partial_word?`',
        Performance::LookupsPartialWordRawTask.new,
      )
    end

    def benchmark_lookups_partial_word_compressed_task
      benchmark_task(
        'Lookups (compressed trie) - `partial_word?`',
        Performance::LookupsPartialWordCompressedTask.new,
      )
    end

    def benchmark_lookups_scan_raw_task
      benchmark_task(
        'Lookups (raw trie) - `scan`',
        Performance::LookupsScanRawTask.new,
      )
    end

    def benchmark_lookups_scan_compressed_task
      benchmark_task(
        'Lookups (compressed trie) - `scan`',
        Performance::LookupsScanCompressedTask.new,
      )
    end

    def benchmark_lookups_words_within_raw_task
      benchmark_task(
        'Lookups (raw trie) - `words_within`',
        Performance::LookupsWordsWithinRawTask.new,
      )
    end

    def benchmark_lookups_words_within_compressed_task
      benchmark_task(
        'Lookups (compressed trie) - `words_within`',
        Performance::LookupsWordsWithinCompressedTask.new,
      )
    end
  end
end
