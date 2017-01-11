namespace :performance do
  namespace :profile do
    include Helpers::Path
    include Helpers::Time
    include Helpers::Util
    include Helpers::GC

    namespace :memory do
      desc 'Output banner'
      task :banner do
        performance_report.start 'Memory profile'
      end

      desc 'Generate memory profiling reports for creation'
      task creation: ['performance:directory', :banner] do
        output.puts 'Generating memory profiling reports for creation...'

        memory_profile = MemoryProfile.new 'creation'
        memory_profile.perform do
          Rambling::Trie.create dictionary
        end
      end

      desc 'Generate memory profiling reports for compression'
      task compression: ['performance:directory', :banner] do
        output.puts 'Generating memory profiling reports for compression...'
        trie = Rambling::Trie.load raw_trie_path

        memory_profile = MemoryProfile.new 'compression'
        memory_profile.perform do
          trie.compress!
        end

        with_gc_stats { GC.start }
      end

      namespace :serialization do
        desc 'Generate memory profiling reports for serialization (raw)'
        task raw: ['performance:directory', :banner] do
          output.puts 'Generating memory profiling reports for serialization (raw)...'

          memory_profile = MemoryProfile.new 'serialization-raw'
          memory_profile.perform do
            Rambling::Trie.load raw_trie_path
          end
        end

        desc 'Generate memory profiling reports for serialization (compressed)'
        task compressed: ['performance:directory', :banner] do
          output.puts 'Generating memory profiling reports for serialization (compressed)...'

          memory_profile = MemoryProfile.new 'serialization-compressed'
          memory_profile.perform do
            Rambling::Trie.load compressed_trie_path
          end
        end
      end

      desc 'Generate memory profiling reports for lookups'
      task lookups: ['performance:directory', :banner] do
        output.puts 'Generating memory profiling reports for lookups...'

        words = %w(hi help beautiful impressionism anthropological)
        times = 10

        tries.each do |trie|
          prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
          memory_profile = MemoryProfile.new "#{prefix}-word"
          memory_profile.perform do
            words.each do |word|
              times.times do
                trie.word? word
              end
            end
          end
        end

        tries.each do |trie|
          prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
          memory_profile = MemoryProfile.new "#{prefix}-partial-word"
          memory_profile.perform do
            words.each do |word|
              times.times do
                trie.partial_word? word
              end
            end
          end
        end
      end

      desc 'Generate memory profiling reports for scans'
      task scans: ['performance:directory', :banner] do
        output.puts 'Generating memory profiling reports for scans...'

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
            words.each do |word, times|
              times.times do
                trie.scan(word.to_s).size
              end
            end
          end
        end
      end

      desc 'Generate all memory profiling reports'
      task all: [
        :creation,
        :compression,
        'serialization:raw',
        'serialization:compressed',
        :lookups,
        :scans,
      ]
    end
  end
end
