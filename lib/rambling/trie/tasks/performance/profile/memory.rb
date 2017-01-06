namespace :performance do
  namespace :profile do
    include Helpers::Path
    include Helpers::Time

    def performance_report
      @performance_report ||= PerformanceReport.new
    end

    def output
      performance_report.output
    end

    class MemoryProfile
      def initialize name
        @name = name
      end

      def perform
        result = MemoryProfiler.report allow_files: 'lib/rambling/trie', ignore_files: 'lib/rambling/trie/tasks' do
          with_gc_stats do
            yield
          end
        end

        dir = path 'reports', Rambling::Trie::VERSION, 'memory', time
        FileUtils.mkdir_p dir
        result.pretty_print to_file: File.join(dir, name)
      end

      private

      attr_reader :name
    end

    def with_gc_stats
      output.puts "Live objects before - #{GC.stat[:heap_live_slots]}"
      yield
      output.puts "Live objects after  - #{GC.stat[:heap_live_slots]}"
    end

    namespace :memory do
      desc 'Output banner'
      task :banner do
        performance_report.start 'Memory profile'
      end

      desc 'Generate memory profiling reports for creation'
      task creation: ['performance:directory', :banner] do
        output.puts 'Generating memory profiling reports for creation...'

        trie = nil

        memory_profile = MemoryProfile.new 'memory-profile-new-trie'
        memory_profile.perform do
          trie = Rambling::Trie.create dictionary
        end
      end

      desc 'Generate memory profiling reports for compression'
      task compression: ['performance:directory', :banner] do
        output.puts 'Generating memory profiling reports for compression...'
        trie = Rambling::Trie.create dictionary

        memory_profile = MemoryProfile.new 'memory-profile-trie-and-compress'
        memory_profile.perform do
          trie.compress!
        end

        with_gc_stats { GC.start }
      end

      desc 'Generate memory profiling reports for lookups'
      task lookups: ['performance:directory', :banner] do
        output.puts 'Generating memory profiling reports for lookups...'

        words = %w(hi help beautiful impressionism anthropological)

        trie = Rambling::Trie.create dictionary
        compressed_trie = Rambling::Trie.create(dictionary).compress!
        [ trie, compressed_trie ].each do |trie|
          times = 10

          prefix = "memory-profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
          name = "#{prefix}-word"
          memory_profile = MemoryProfile.new name
          memory_profile.perform do
            words.each do |word|
              times.times do
                trie.word? word
              end
            end
          end

          name = "#{prefix}-partial-word"
          memory_profile = MemoryProfile.new name
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

        trie = Rambling::Trie.create dictionary
        compressed_trie = Rambling::Trie.create(dictionary).compress!
        [ trie, compressed_trie ].each do |trie|
          name = "memory-profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie-scan"
          memory_profile = MemoryProfile.new name
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
        :lookups,
        :scans,
      ]
    end
  end
end
