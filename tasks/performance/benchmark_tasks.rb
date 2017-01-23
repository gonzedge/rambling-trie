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

    def benchmark_creation_task
      lambda do |output|
        output.puts
        output.puts '==> Creation - `Rambling::Trie.create`'

        task = Performance::CreationTask.new
        task.execute Performance::Benchmark
      end
    end

    def benchmark_lookups_scan_task
      lambda do |output|
        output.puts
        output.puts '==> Lookups - `scan`'

        task = Performance::LookupsScanTask.new
        tries.each do |trie|
          output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
          task.execute Performance::Benchmark, trie
        end
      end
    end

    def benchmark_lookups_words_within_task
      lambda do |output|
        output.puts
        output.puts '==> Lookups - `words_within`'

        task = Performance::LookupsWordsWithinTask.new
        tries.each do |trie|
          output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
          task.execute Performance::Benchmark, trie
        end
      end
    end

    def benchmark_lookups_partial_word_task
      lambda do |output|
        output.puts
        output.puts '==> Lookups - `partial_word?`'

        task = Performance::LookupsPartialWordTask.new
        tries.each do |trie|
          output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
          task.execute Performance::Benchmark, trie
        end
      end
    end

    def benchmark_lookups_word_task
      lambda do |output|
        output.puts
        output.puts '==> Lookups - `word?`'

        task = Performance::LookupsWordTask.new
        tries.each do |trie|
          output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
          task.execute Performance::Benchmark, trie
        end
      end
    end

    def benchmark_serialization_compressed_task
      lambda do |output|
        output.puts
        output.puts '==> Serialization (compressed trie) - `Rambling::Trie.load`'

        task = Performance::SerializationCompressedTask.new
        task.execute Performance::Benchmark
      end
    end

    def benchmark_serialization_raw_task
      lambda do |output|
        output.puts
        output.puts '==> Serialization (raw trie) - `Rambling::Trie.load`'

        task = Performance::SerializationRawTask.new
        task.execute Performance::Benchmark
      end
    end

    def benchmark_compression_task
      lambda do |output|
        output.puts
        output.puts '==> Compression - `compress!`'

        task = Performance::CompressionTask.new
        task.execute Performance::Benchmark
      end
    end
  end
end
