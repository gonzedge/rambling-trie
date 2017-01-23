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
  module BenchmarkTasks
    include Helpers::Trie

    def benchmark_tasks
      {
        'creation' => benchmark_creation_task,
        'compression' => benchmark_compression_task,
        'serialization:raw' => benchmark_serialization_raw_task,
        'serialization:compressed' => benchmark_serialization_compressed_task,
        'lookups:word' => benchmark_lookups_word_task,
        'lookups:partial_word' => benchmark_lookups_partial_word_task,
        'lookups:scan' => benchmark_lookups_scan_task,
        'lookups:words_within' => benchmark_lookups_words_within_task,
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

    def benchmark_multiple_tries_task title, task
      lambda do |output|
        banner output, title
        tries.each do |trie|
          output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
          task.execute Performance::Benchmark, trie
        end
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

    def benchmark_lookups_word_task
      benchmark_multiple_tries_task(
        'Lookups - `word?`',
        Performance::LookupsWordTask.new,
      )
    end

    def benchmark_lookups_partial_word_task
      benchmark_multiple_tries_task(
        'Lookups - `partial_word?`',
        Performance::LookupsPartialWordTask.new,
      )
    end

    def benchmark_lookups_scan_task
      benchmark_multiple_tries_task(
        'Lookups - `scan`',
        Performance::LookupsScanTask.new,
      )
    end

    def benchmark_lookups_words_within_task
      benchmark_multiple_tries_task(
        'Lookups - `words_within`',
        Performance::LookupsWordsWithinTask.new,
      )
    end
  end
end
