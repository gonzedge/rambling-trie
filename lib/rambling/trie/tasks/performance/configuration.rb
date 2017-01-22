require_relative '../helpers/gc'
require_relative '../helpers/path'
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
  class Configuration
    include Helpers::GC
    include Helpers::Path
    include Helpers::Trie

    def get type, method
      type ||= 'all'
      method ||= 'all'

      if type == 'all'
        lambda do |output|
          tasks.keys.each do |type|
            output.puts
            output.puts "Running #{type} tasks..."
            get(type, method).call output
          end
        end
      elsif method == 'all'
        lambda do |output|
          tasks[type].each do |method, task|
            task.call output
          end
        end
      else
        tasks[type][method]
      end
    end

    def tasks
      {
        'benchmark' => benchmark_tasks,
        'call_tree' => call_tree_tasks,
        'memory' => memory_tasks,
        'flamegraph' => flamegraph_tasks
      }
    end

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

    def flamegraph_tasks
      {
        'creation' => flamegraph_creation_task,
        'compression' => flamegraph_compression_task,
        'serialization:raw' => flamegraph_serialization_raw_task,
        'serialization:compressed' => flamegraph_serialization_compressed_task,
        'lookups:word' => flamegraph_lookups_word_task,
        'lookups:partial_word' => flamegraph_lookups_partial_word_task,
        'lookups:scan' => flamegraph_lookups_scan_task,
        'lookups:words_within' => flamegraph_lookups_words_within_task,
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

    def memory_lookups_scan_task
      lambda do |output|
        task = Performance::LookupsScanTask.new(
          hi: 1,
          help: 100,
          beautiful: 100,
          impressionism: 200,
          anthropological: 200,
        )

        tries.each do |trie|
          task.execute Performance::MemoryProfile, trie
        end
      end
    end

    def memory_lookups_words_within_task
      lambda do |output|
        task = Performance::LookupsWordsWithinTask.new 10
        tries.each do |trie|
          task.execute Performance::MemoryProfile, trie
        end
      end
    end

    def memory_lookups_partial_word_task
      lambda do |output|
        task = Performance::LookupsPartialWordTask.new 10
        tries.each do |trie|
          task.execute Performance::MemoryProfile, trie
        end
      end
    end

    def memory_lookups_word_task
      lambda do |output|
        task = Performance::LookupsWordTask.new 10
        tries.each do |trie|
          task.execute Performance::MemoryProfile, trie
        end
      end
    end

    def memory_serialization_compressed_task
      lambda do |output|
        task = Performance::SerializationCompressedTask.new 1
        task.execute Performance::MemoryProfile
      end
    end

    def memory_serialization_raw_task
      lambda do |output|
        task = Performance::SerializationRawTask.new 1
        task.execute Performance::MemoryProfile
      end
    end

    def memory_compression_task
      lambda do |output|
        task = Performance::CompressionTask.new 1
        task.execute Performance::MemoryProfile
        with_gc_stats 'garbage collection' do
          GC.start
        end
      end
    end

    def memory_creation_task
      lambda do |output|
        task = Performance::CreationTask.new 1
        task.execute Performance::MemoryProfile
      end
    end

    def flamegraph_lookups_scan_task
      lambda do |output|
        task = Performance::LookupsScanTask.new(
          hi: 1,
          help: 1,
          beautiful: 1,
          impressionism: 1,
          anthropological: 1,
        )

        tries.each do |trie|
          task.execute Performance::FlamegraphProfile, trie
        end
      end
    end

    def flamegraph_lookups_words_within_task
      lambda do |output|
        task = Performance::LookupsWordsWithinTask.new 1
        tries.each do |trie|
          task.execute Performance::FlamegraphProfile, trie
        end
      end
    end

    def flamegraph_lookups_partial_word_task
      lambda do |output|
        task = Performance::LookupsPartialWordTask.new 1
        tries.each do |trie|
          task.execute Performance::FlamegraphProfile, trie
        end
      end
    end

    def flamegraph_lookups_word_task
      lambda do |output|
        task = Performance::LookupsWordTask.new 1
        tries.each do |trie|
          task.execute Performance::FlamegraphProfile, trie
        end
      end
    end

    def flamegraph_serialization_compressed_task
      lambda do |output|
        task = Performance::SerializationCompressedTask.new 1
        task.execute Performance::FlamegraphProfile
      end
    end

    def flamegraph_serialization_raw_task
      lambda do |output|
        task = Performance::SerializationRawTask.new 1
        task.execute Performance::FlamegraphProfile
      end
    end

    def flamegraph_compression_task
      lambda do |output|
        task = Performance::CompressionTask.new 1
        task.execute Performance::FlamegraphProfile
      end
    end

    def flamegraph_creation_task
      lambda do |output|
        task = Performance::CreationTask.new 1
        task.execute Performance::FlamegraphProfile
      end
    end
  end
end
