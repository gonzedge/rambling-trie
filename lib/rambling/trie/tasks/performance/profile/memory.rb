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

      result = MemoryProfiler.report allow_files: 'lib/rambling/trie', ignore_files: 'tasks/performance' do
        yield
      end

      dir = path 'reports', Rambling::Trie::VERSION, 'memory', time.to_s
      FileUtils.mkdir_p dir
      result.pretty_print to_file: File.join(dir, name)
    end

    def dictionary
      dictionary = path 'assets', 'dictionaries', 'words_with_friends.txt'
    end

    namespace :memory do
      task creation: ['performance:directory'] do
        puts 'Generating memory profiling reports for creation...'

        trie = nil

        memory_profile "memory-profile-new-trie" do
          with_gc_stats { trie = Rambling::Trie.create dictionary }
        end
      end

      task compression: ['performance:directory'] do
        trie = Rambling::Trie.create dictionary

        memory_profile "memory-profile-trie-and-compress" do
          with_gc_stats { trie.compress! }
        end

        with_gc_stats { GC.start }
      end

      task lookups: ['performance:directory'] do
        trie = Rambling::Trie.create dictionary
        words = %w(hi help beautiful impressionism anthropological)

        tries = [ trie, trie.clone.compress! ]

        tries.each do |trie|
          times = 10

          name = "memory-profile-searching-#{trie.compressed? ? 'uncompressed' : 'compressed'}-trie-word"
          memory_profile name do
            with_gc_stats do
              words.each do |word|
                times.times do
                  trie.word? word
                end
              end
            end
          end

          name = "memory-profile-searching-#{trie.compressed? ? 'uncompressed' : 'compressed'}-trie-partial-word"
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

      task all: [
        'performance:profile:memory:creation',
        'performance:profile:memory:compression',
        'performance:profile:memory:lookups'
      ]
    end
  end
end
