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
        'creation' => lambda do |output|
          output.puts
          output.puts '==> Creation - `Rambling::Trie.create`'

          task = Performance::CreationTask.new
          task.execute Performance::Benchmark
        end,
        'compression' => lambda do |output|
          output.puts
          output.puts '==> Compression - `compress!`'

          task = Performance::CompressionTask.new
          task.execute Performance::Benchmark
        end,
        'serialization:raw' => lambda do |output|
          output.puts
          output.puts '==> Serialization (raw trie) - `Rambling::Trie.load`'

          task = Performance::SerializationRawTask.new
          task.execute Performance::Benchmark
        end,
        'serialization:compressed' => lambda do |output|
          output.puts
          output.puts '==> Serialization (compressed trie) - `Rambling::Trie.load`'

          task = Performance::SerializationCompressedTask.new
          task.execute Performance::Benchmark
        end,
        'lookups:word' => lambda do |output|
          output.puts
          output.puts '==> Lookups - `word?`'

          task = Performance::LookupsWordTask.new
          tries.each do |trie|
            output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
            task.execute Performance::Benchmark, trie
          end
        end,
        'lookups:partial_word' => lambda do |output|
          output.puts
          output.puts '==> Lookups - `partial_word?`'

          task = Performance::LookupsPartialWordTask.new
          tries.each do |trie|
            output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
            task.execute Performance::Benchmark, trie
          end
        end,
        'lookups:words_within' => lambda do |output|
          output.puts
          output.puts '==> Lookups - `words_within`'

          task = Performance::LookupsWordsWithinTask.new
          tries.each do |trie|
            output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
            task.execute Performance::Benchmark, trie
          end
        end,
        'lookups:scan' => lambda do |output|
          output.puts
          output.puts '==> Lookups - `scan`'

          task = Performance::LookupsScanTask.new
          tries.each do |trie|
            output.puts "--- #{trie.compressed? ? 'Compressed' : 'Raw'}"
            task.execute Performance::Benchmark, trie
          end
        end,
      }
    end

    def call_tree_tasks
      {
        'creation' => lambda do |output|
          task = Performance::CreationTask.new
          task.execute Performance::CallTreeProfile
        end,
        'compression' => lambda do |output|
          task = Performance::CompressionTask.new
          task.execute Performance::CallTreeProfile
        end,
        'serialization:raw' => lambda do |output|
          task = Performance::SerializationRawTask.new
          task.execute Performance::CallTreeProfile
        end,
        'serialization:compressed' => lambda do |output|
          task = Performance::SerializationCompressedTask.new
          task.execute Performance::CallTreeProfile
        end,
        'lookups:word' => lambda do |output|
          task = Performance::LookupsWordTask.new
          tries.each do |trie|
            task.execute Performance::CallTreeProfile, trie
          end
        end,
        'lookups:partial_word' => lambda do |output|
          task = Performance::LookupsPartialWordTask.new
          tries.each do |trie|
            task.execute Performance::CallTreeProfile, trie
          end
        end,
        'lookups:words_within' => lambda do |output|
          task = Performance::LookupsWordsWithinTask.new
          tries.each do |trie|
            task.execute Performance::CallTreeProfile, trie
          end
        end,
        'lookups:scan' => lambda do |output|
          task = Performance::LookupsScanTask.new
          tries.each do |trie|
            task.execute Performance::CallTreeProfile, trie
          end
        end,
      }
    end

    def memory_tasks
      {
        'creation' => lambda do |output|
          task = Performance::CreationTask.new 1
          task.execute Performance::MemoryProfile
        end,
        'compression' => lambda do |output|
          task = Performance::CompressionTask.new 1
          task.execute Performance::MemoryProfile
          with_gc_stats 'garbage collection' do
            GC.start
          end
        end,
        'serialization:raw' => lambda do |output|
          task = Performance::SerializationRawTask.new 1
          task.execute Performance::MemoryProfile
        end,
        'serialization:compressed' => lambda do |output|
          task = Performance::SerializationCompressedTask.new 1
          task.execute Performance::MemoryProfile
        end,
        'lookups:word' => lambda do |output|
          task = Performance::LookupsWordTask.new 10
          tries.each do |trie|
            task.execute Performance::MemoryProfile, trie
          end
        end,
        'lookups:partial_word' => lambda do |output|
          task = Performance::LookupsPartialWordTask.new 10
          tries.each do |trie|
            task.execute Performance::MemoryProfile, trie
          end
        end,
        'lookups:words_within' => lambda do |output|
          task = Performance::LookupsWordsWithinTask.new 10
          tries.each do |trie|
            task.execute Performance::MemoryProfile, trie
          end
        end,
        'lookups:scan' => lambda do |output|
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
        end,
      }
    end

    def flamegraph_tasks
      {
        'creation' => lambda do |output|
          task = Performance::CreationTask.new 1
          task.execute Performance::FlamegraphProfile
        end,
        'compression' => lambda do |output|
          task = Performance::CompressionTask.new 1
          task.execute Performance::FlamegraphProfile
        end,
        'serialization:raw' => lambda do |output|
          task = Performance::SerializationRawTask.new 1
          task.execute Performance::FlamegraphProfile
        end,
        'serialization:compressed' => lambda do |output|
          task = Performance::SerializationCompressedTask.new 1
          task.execute Performance::FlamegraphProfile
        end,
        'lookups:word' => lambda do |output|
          task = Performance::LookupsWordTask.new 1
          tries.each do |trie|
            task.execute Performance::FlamegraphProfile, trie
          end
        end,
        'lookups:partial_word' => lambda do |output|
          task = Performance::LookupsPartialWordTask.new 1
          tries.each do |trie|
            task.execute Performance::FlamegraphProfile, trie
          end
        end,
        'lookups:words_within' => lambda do |output|
          task = Performance::LookupsWordsWithinTask.new 1
          tries.each do |trie|
            task.execute Performance::FlamegraphProfile, trie
          end
        end,
        'lookups:scan' => lambda do |output|
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
        end,
      }
    end
  end
end
