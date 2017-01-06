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

    class CallTreeProfile
      def initialize dirname
        @dirname = dirname
      end

      def perform times, params = nil
        params = Array params
        params << nil unless params.any?

        result = RubyProf.profile merge_fibers: true do
          params.each do |param|
            times.times do
              yield param
            end
          end
        end

        path = path 'reports', Rambling::Trie::VERSION, 'call-tree', time, dirname
        FileUtils.mkdir_p path
        printer = RubyProf::CallTreePrinter.new result
        printer.print path: path
      end

      private

      attr_reader :dirname
    end

    def generate_lookups_call_tree
      output.puts 'Generating call tree profiling reports for lookups...'

      words = %w(hi help beautiful impressionism anthropological)

      trie = Rambling::Trie.create dictionary
      compressed_trie = Rambling::Trie.create(dictionary).compress!

      [ trie, compressed_trie ].each do |trie|
        prefix = "profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}"

        call_tree_profile = CallTreeProfile.new "#{prefix}-word"
        call_tree_profile.perform 200_000, words do
          trie.word? word
        end

        call_tree_profile = CallTreeProfile.new "#{prefix}-partial-word"
        call_tree_profile.perform 200_000, words do
          trie.partial_word? word
        end
      end

      output.puts 'Done'
    end

    def generate_scans_call_tree
      output.puts 'Generating call tree profiling reports for scans...'

      words = {
        hi: 1_000,
        help: 100_000,
        beautiful: 100_000,
        impressionism: 200_000,
        anthropological: 200_000,
      }

      trie = Rambling::Trie.create dictionary
      compressed_trie = Rambling::Trie.create(dictionary).compress!

      [ trie, compressed_trie ].each do |trie|
        dirname = "profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-scan"
        call_tree_profile = CallTreeProfile.new dirname

        words.each do |word, times|
          call_tree_profile.perform times, word.to_s do |word|
            trie.scan(word).size
          end
        end
      end

      output.puts 'Done'
    end

    namespace :call_tree do
      desc 'Output banner'
      task :banner do
        performance_report.start 'Call Tree profile'
      end

      desc 'Generate call tree profiling reports for creation'
      task creation: ['performance:directory', :banner] do
        output.puts 'Generating call tree profiling reports for creation...'

        call_tree_profile = CallTreeProfile.new 'profile-new-trie'
        call_tree_profile.perform 5 do
          trie = Rambling::Trie.create dictionary
        end

        output.puts 'Done'
      end

      desc 'Generate call tree profiling reports for compression'
      task compression: ['performance:directory', :banner] do
        output.puts 'Generating call tree profiling reports for compression...'

        tries = []
        5.times { tries << Rambling::Trie.create(dictionary) }

        call_tree_profile = CallTreeProfile.new 'profile-compressed-trie'
        call_tree_profile.perform 5, tries do |trie|
          trie.compress!; nil
        end

        output.puts 'Done'
      end

      desc 'Generate call tree profiling reports for lookups'
      task lookups: ['performance:directory', :banner] do
        generate_lookups_call_tree
      end

      desc 'Generate call tree profiling reports for scans'
      task scans: ['performance:directory', :banner] do
        generate_scans_call_tree
      end

      desc 'Generate all call tree profiling reports'
      task all: [
        :creation,
        :compression,
        :lookups,
        :scans,
      ]
    end
  end
end
