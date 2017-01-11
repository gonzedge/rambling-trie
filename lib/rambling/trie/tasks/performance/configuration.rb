module Performance
  class Configuration
    include Helpers::GC
    include Helpers::Path
    include Helpers::Trie

    def get type, method = 'all'
      if type == 'all'
        lambda { |output| tasks.keys.each { |type| get(type).call output } }
      elsif method == 'all'
        lambda { |output| tasks[type].each { |method, task| task.call output } }
      else
        tasks[type][method]
      end
    end

    def tasks
      {
        'benchmark' => {
          'creation' => lambda do |output|
            task = execution_tasks['creation']
            measure = BenchmarkMeasurement.new output

            output.puts
            output.puts '==> Creation - `Rambling::Trie.create`'
            measure.perform 5 do
              task.call
            end
          end,
          'compression' => lambda do |output|
            task = execution_tasks['compression']
            measure = BenchmarkMeasurement.new output

            output.puts
            output.puts '==> Compression - `compress!`'

            tries = []
            5.times { tries << Rambling::Trie.load(raw_trie_path) }

            i = 0
            measure.perform 5 do |trie|
              task.call tries[i]
              i = i + 1
              nil
            end
          end,
          'serialization:raw' => lambda do |output|
            task = execution_tasks['serialization:raw']
            measure = BenchmarkMeasurement.new output

            output.puts
            output.puts '==> Serialization (raw trie) - `Rambling::Trie.load`'
            measure.perform 5 do
              task.call
            end
          end,
          'serialization:compressed' => lambda do |output|
            task = execution_tasks['serialization:compressed']
            measure = BenchmarkMeasurement.new output

            output.puts
            output.puts '==> Serialization (compressed trie) - `Rambling::Trie.load`'
            measure.perform 5 do
              task.call
            end
          end,
          'lookups:word' => lambda do |output|
            task = execution_tasks['lookups:word']
            words = %w(hi help beautiful impressionism anthropological)
            measure = BenchmarkMeasurement.new output

            output.puts
            output.puts '==> Lookups - `word?`'
            tries.each do |trie|
              output.puts "--- #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
              measure.perform 200_000, words do |word|
                task.call trie, word
              end
            end
          end,
          'lookups:partial_word' => lambda do |output|
            task = execution_tasks['lookups:partial_word']
            words = %w(hi help beautiful impressionism anthropological)
            measure = BenchmarkMeasurement.new output

            output.puts
            output.puts '==> Lookups - `partial_word?`'
            tries.each do |trie|
              output.puts "--- #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
              measure.perform 200_000, words do |word|
                task.call trie, word
              end
            end
          end,
          'lookups:scan' => lambda do |output|
            task = execution_tasks['lookups:scan']
            words = {
              hi: 1_000,
              help: 100_000,
              beautiful: 100_000,
              impressionism: 200_000,
              anthropological: 200_000,
            }

            measure = BenchmarkMeasurement.new output

            output.puts
            output.puts '==> Lookups - `scan`'
            tries.each do |trie|
              output.puts "--- #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
              words.each do |word, iterations|
                measure.perform iterations, word.to_s do |word|
                  task.call trie, word
                end
              end
            end
          end,
        },
        'call_tree' => {
          'creation' => lambda do |output|
            output.puts 'Generating call tree profiling reports for creation...'
            task = execution_tasks['creation']

            call_tree_profile = CallTreeProfile.new 'creation'
            call_tree_profile.perform 5 do
              task.call
            end

            output.puts 'Done'
          end,
          'compression' => lambda do |output|
            task = execution_tasks['compression']
            output.puts 'Generating call tree profiling reports for compression...'

            tries = []
            5.times { tries << Rambling::Trie.load(raw_trie_path) }

            call_tree_profile = CallTreeProfile.new 'compression'
            call_tree_profile.perform 5, tries do |trie|
              task.call trie
            end

            output.puts 'Done'
          end,
          'serialization:raw' => lambda do |output|
            task = execution_tasks['serialization:raw']
            output.puts 'Generating call tree profiling reports for serialization (raw)...'

            call_tree_profile = CallTreeProfile.new 'serialization-raw'
            call_tree_profile.perform 5 do
              task.call
            end

            output.puts 'Done'
          end,
          'serialization:compressed' => lambda do |output|
            task = execution_tasks['serialization:compressed']
            output.puts 'Generating call tree profiling reports for serialization (compressed)...'

            call_tree_profile = CallTreeProfile.new 'serialization-compressed'
            call_tree_profile.perform 5 do
              task.call
            end

            output.puts 'Done'
          end,
          'lookups:word' => lambda do |output|
            task = execution_tasks['lookups:word']
            output.puts 'Generating call tree profiling reports for lookups...'

            words = %w(hi help beautiful impressionism anthropological)

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"

              call_tree_profile = CallTreeProfile.new "#{prefix}-word"
              call_tree_profile.perform 200_000, words do |word|
                task.call trie, word
              end
            end

            output.puts 'Done'
          end,
          'lookups:partial_word' => lambda do |output|
            task = execution_tasks['lookups:partial_word']
            output.puts 'Generating call tree profiling reports for lookups...'

            words = %w(hi help beautiful impressionism anthropological)

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"

              call_tree_profile = CallTreeProfile.new "#{prefix}-partial-word"
              call_tree_profile.perform 200_000, words do |word|
                task.call trie, word
              end
            end

            output.puts 'Done'
          end,
          'lookups:scan' => lambda do |output|
            task = execution_tasks['lookups:scan']
            output.puts 'Generating call tree profiling reports for scans...'

            words = {
              hi: 1_000,
              help: 100_000,
              beautiful: 100_000,
              impressionism: 200_000,
              anthropological: 200_000,
            }

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
              call_tree_profile = CallTreeProfile.new "#{prefix}-scan"

              words.each do |word, iterations|
                call_tree_profile.perform iterations, word.to_s do |word|
                  task.call trie, word
                end
              end
            end

            output.puts 'Done'
          end,
        },
        'memory' => {
          'creation' => lambda do |output|
            output.puts 'Generating memory profiling reports for creation...'
            task = execution_tasks['creation']

            memory_profile = MemoryProfile.new 'creation'
            memory_profile.perform do
              task.call
            end
          end,
          'compression' => lambda do |output|
            output.puts 'Generating memory profiling reports for compression...'
            task = execution_tasks['compression']

            trie = Rambling::Trie.load raw_trie_path

            memory_profile = MemoryProfile.new 'compression'
            memory_profile.perform do
              task.call trie
            end

            with_gc_stats { GC.start }
          end,
          'serialization:raw' => lambda do |output|
            output.puts 'Generating memory profiling reports for serialization (raw)...'
            task = execution_tasks['serialization:raw']

            memory_profile = MemoryProfile.new 'serialization-raw'
            memory_profile.perform do
              task.call
            end
          end,
          'serialization:compressed' => lambda do |output|
            output.puts 'Generating memory profiling reports for serialization (compressed)...'
            task = execution_tasks['serialization:compressed']

            memory_profile = MemoryProfile.new 'serialization-compressed'
            memory_profile.perform do
              task.call
            end
          end,
          'lookups:word' => lambda do |output|
            output.puts 'Generating memory profiling reports for lookups...'
            task = execution_tasks['lookups:word']

            words = %w(hi help beautiful impressionism anthropological)
            iterations = 10

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
              memory_profile = MemoryProfile.new "#{prefix}-word"
              memory_profile.perform do
                words.each do |word|
                  iterations.times do
                    task.call trie, word
                  end
                end
              end
            end
          end,
          'lookups:partial_word' => lambda do |output|
            output.puts 'Generating memory profiling reports for lookups...'
            task = execution_tasks['lookups:partial_word']

            words = %w(hi help beautiful impressionism anthropological)
            iterations = 10

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
              memory_profile = MemoryProfile.new "#{prefix}-partial-word"
              memory_profile.perform do
                words.each do |word|
                  iterations.times do
                    task.call trie, word
                  end
                end
              end
            end
          end,
          'lookups:scan' => lambda do |output|
            output.puts 'Generating memory profiling reports for scans...'
            task = execution_tasks['lookups:scan']

            words = {
              hi: 1,
              help: 100,
              beautiful: 100,
              impressionism: 200,
              anthropological: 200,
            }

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
              memory_profile = MemoryProfile.new "#{prefix}-scan"
              memory_profile.perform do
                words.each do |word, iterations|
                  iterations.times do
                    task.call trie, word.to_s
                  end
                end
              end
            end
          end,
        },
        'flamegraph' => {
          'creation' => lambda do |output|
            task = execution_tasks['creation']
            output.puts 'Generating flamegraph reports for creation...'

            flamegraph = FlamegraphProfile.new 'creation'
            flamegraph.perform 1 do
              task.call
            end
          end,
          'compression' => lambda do |output|
            task = execution_tasks['compression']
            output.puts 'Generating flamegraph reports for compression...'

            trie = Rambling::Trie.load raw_trie_path

            flamegraph = FlamegraphProfile.new 'compression'
            flamegraph.perform 1 do
              task.call trie
            end
          end,
          'serialization:raw' => lambda do |output|
            task = execution_tasks['serialization:raw']
            output.puts 'Generating flamegraph reports for serialization (raw)...'

            flamegraph = FlamegraphProfile.new 'serialization-raw'
            flamegraph.perform 1 do
              task.call
            end
          end,
          'serialization:compressed' => lambda do |output|
            task = execution_tasks['serialization:compressed']
            output.puts 'Generating flamegraph reports for serialization (compressed)...'

            flamegraph = FlamegraphProfile.new 'serialization-compressed'
            flamegraph.perform 1 do
              task.call
            end
          end,
          'lookups:word' => lambda do |output|
            task = execution_tasks['lookups:word']
            output.puts 'Generating flamegraph reports for lookups...'

            words = %w(hi help beautiful impressionism anthropological)

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"

              flamegraph = FlamegraphProfile.new "#{prefix}-word"
              flamegraph.perform 1, words do |word|
                task.call trie, word
              end
            end
          end,
          'lookups:partial_word' => lambda do |output|
            task = execution_tasks['lookups:partial_word']
            output.puts 'Generating flamegraph reports for lookups...'

            words = %w(hi help beautiful impressionism anthropological)

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
              flamegraph = FlamegraphProfile.new "#{prefix}-partial-word"
              flamegraph.perform 1, words do |word|
                task.call trie, word
              end
            end
          end,
          'lookups:scan' => lambda do |output|
            task = execution_tasks['lookups:scan']
            output.puts 'Generating flamegraph reports for scans...'

            words = %w(hi help beautiful impressionism anthropological)

            tries.each do |trie|
              prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
              flamegraph = FlamegraphProfile.new "#{prefix}-scan"
              flamegraph.perform 1, words do |word|
                task.call trie, word.to_s
              end
            end
          end,
        }
      }
    end

    def execution_tasks
      {
        'creation' => lambda { Rambling::Trie.create dictionary; nil },
        'compression' => lambda { |trie| trie.compress!; nil },
        'serialization:raw' => lambda { Rambling::Trie.load raw_trie_path; nil },
        'serialization:compressed' => lambda { Rambling::Trie.load compressed_trie_path; nil },
        'lookups:word' => lambda { |trie, word| trie.word? word },
        'lookups:partial_word' => lambda { |trie, word| trie.partial_word? word },
        'lookups:scan' => lambda { |trie, word| trie.scan(word).size },
      }
    end
  end
end
