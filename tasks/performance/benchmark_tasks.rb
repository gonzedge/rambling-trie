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

    def task title, task_class
      lambda do |output|
        banner output, title
        task = task_class.new
        task.execute Performance::Benchmark
      end
    end

    def multiple_tries_task title, task_class
      lambda do |output|
        banner output, title
        task = task_class.new
        tries.each do |trie|
          output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
          task.execute Performance::Benchmark, trie
        end
      end
    end

    def benchmark_creation_task
      task(
        'Creation - `Rambling::Trie.create`',
        Performance::CreationTask,
      )
    end

    def benchmark_compression_task
      task(
        'Compression - `compress!`',
        Performance::CompressionTask,
      )
    end

    def benchmark_serialization_raw_task
      task(
        'Serialization (raw trie) - `Rambling::Trie.load`',
        Performance::SerializationRawTask,
      )
    end

    def benchmark_serialization_compressed_task
      task(
        'Serialization (compressed trie) - `Rambling::Trie.load`',
        Performance::SerializationCompressedTask,
      )
    end

    def benchmark_lookups_word_task
      multiple_tries_task(
        'Lookups - `word?`',
        Performance::LookupsWordTask,
      )
    end

    def benchmark_lookups_partial_word_task
      multiple_tries_task(
        'Lookups - `partial_word?`',
        Performance::LookupsPartialWordTask,
      )
    end

    def benchmark_lookups_scan_task
      multiple_tries_task(
        'Lookups - `scan`',
        Performance::LookupsScanTask,
      )
    end

    def benchmark_lookups_words_within_task
      multiple_tries_task(
        'Lookups - `words_within`',
        Performance::LookupsWordsWithinTask,
      )
    end
  end
end
