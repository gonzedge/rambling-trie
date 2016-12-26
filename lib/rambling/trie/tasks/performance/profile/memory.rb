require_relative '../../helpers/path'
require_relative '../../helpers/time'

namespace :performance do
  namespace :profile do
    include Helpers::Path
    include Helpers::Time

    def with_gc_stats
      puts "Live objects before - #{GC.stat[:heap_live_slots]}"
      yield
      puts "Live objects after  - #{GC.stat[:heap_live_slots]}"
    end

    def memory_profile name
      puts
      puts name

      result = MemoryProfiler.report allow_files: 'lib/rambling/trie', ignore_files: 'lib/rambling/trie/tasks' do
        yield
      end

      dir = path 'reports', Rambling::Trie::VERSION, 'memory', time
      FileUtils.mkdir_p dir
      result.pretty_print to_file: File.join(dir, name)
    end

    namespace :memory do
      desc 'Generate memory profiling reports for creation'
      task creation: ['performance:directory'] do
        puts 'Generating memory profiling reports for creation...'

        trie = nil

        memory_profile "memory-profile-new-trie" do
          with_gc_stats { trie = Rambling::Trie.create dictionary }
        end
      end

      desc 'Generate memory profiling reports for compression'
      task compression: ['performance:directory'] do
        trie = Rambling::Trie.create dictionary

        memory_profile "memory-profile-trie-and-compress" do
          with_gc_stats { trie.compress! }
        end

        with_gc_stats { GC.start }
      end

      desc 'Generate memory profiling reports for lookups'
      task lookups: ['performance:directory'] do
        words = %w(hi help beautiful impressionism anthropological)

        trie = Rambling::Trie.create dictionary
        compressed_trie = Rambling::Trie.create(dictionary).compress!
        [ trie, compressed_trie ].each do |trie|
          times = 10

          name = "memory-profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie-word"
          memory_profile name do
            with_gc_stats do
              words.each do |word|
                times.times do
                  trie.word? word
                end
              end
            end
          end

          name = "memory-profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie-partial-word"
          memory_profile name do
            with_gc_stats do
              words.each do |word|
                times.times do
                  trie.partial_word? word
                end
              end
            end
          end
        end
      end

      desc 'Generate memory profiling reports for scans'
      task scans: ['performance:directory'] do
        words = {
          hi: 1,
          help: 100,
          beautiful: 100,
          impressionism: 200,
          anthropological: 200,
        }

        trie = Rambling::Trie.create dictionary
        compressed_trie = Rambling::Trie.create(dictionary).compress!
        [ trie, compressed_trie ].each do |trie|
          name = "memory-profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie-scan"
          memory_profile name do
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
        'creation',
        'compression',
        'lookups',
        'scans',
      ]
    end
  end
end
