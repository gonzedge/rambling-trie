namespace :performance do
  include Helpers::Path
  include Helpers::Util

  namespace :benchmark do
    namespace :output do
      desc 'Set task reporting output to file'
      task file: ['performance:directory'] do
        path = path 'reports', Rambling::Trie::VERSION, 'benchmark'
        file = File.open path, 'a+'
        self.performance_report = PerformanceReport.new file
      end

      desc 'Close output stream'
      task :close do
        performance_report.finish
      end
    end

    desc 'Output banner'
    task :banner do
      performance_report.start 'Benchmark'
    end

    desc 'Generate creation performance benchmark report'
    task creation: :banner do
      measure = BenchmarkMeasurement.new output

      output.puts
      output.puts '==> Creation - `Rambling::Trie.create`'
      measure.perform 5 do
        trie = Rambling::Trie.create dictionary
        nil
      end
    end

    desc 'Generate compression performance benchmark report'
    task compression: :banner do
      measure = BenchmarkMeasurement.new output

      output.puts
      output.puts '==> Compression - `compress!`'

      tries = []
      5.times { tries << Rambling::Trie.load(raw_trie_path) }

      measure.perform 5, tries do |trie|
        trie.compress!
        nil
      end
    end

    namespace :serialization do
      desc 'Generate serialization performance benchmark report (raw trie)'
      task raw: :banner do
        measure = BenchmarkMeasurement.new output

        output.puts
        output.puts '==> Serialization (raw trie) - `Rambling::Trie.load`'
        measure.perform 5 do
          trie = Rambling::Trie.load raw_trie_path
          nil
        end
      end

      desc 'Generate serialization performance benchmark report (compressed trie)'
      task compressed: :banner do
        measure = BenchmarkMeasurement.new output

        output.puts
        output.puts '==> Serialization (compressed trie) - `Rambling::Trie.load`'
        measure.perform 5 do
          trie = Rambling::Trie.load compressed_trie_path
          nil
        end
      end
    end

    desc 'Generate lookups performance benchmark report'
    task lookups: :banner do
      measure = BenchmarkMeasurement.new output

      words = %w(hi help beautiful impressionism anthropological)

      output.puts
      output.puts '==> Lookups - `word?`'
      tries.each do |trie|
        output.puts "--- #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"

        measure.perform 200_000, words do |word|
          trie.word? word
        end
      end

      output.puts
      output.puts '==> Lookups - `partial_word?`'
      tries.each do |trie|
        output.puts "--- #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"

        measure.perform 200_000, words do |word|
          trie.partial_word? word
        end
      end
    end

    desc 'Generate scans performance benchmark report'
    task scans: :banner do
      measure = BenchmarkMeasurement.new output

      words = {
        hi: 1_000,
        help: 100_000,
        beautiful: 100_000,
        impressionism: 200_000,
        anthropological: 200_000,
      }

      output.puts
      output.puts '==> Scans - `scan`'
      tries.each do |trie|
        output.puts "--- #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
        words.each do |word, times|
          measure.perform times, word.to_s do |word|
            trie.scan(word).size
          end
        end
      end
    end

    desc 'Generate all performance benchmark reports'
    task all: [
      :creation,
      :compression,
      'serialization:raw',
      'serialization:compressed',
      :lookups,
      :scans,
    ]

    namespace :all do
      desc "Generate and store performance benchmark report in reports/#{Rambling::Trie::VERSION}"
      task save: [
        'output:file',
        :all
      ]
    end

    desc 'Compare ips for different implementations (changes over time)'
    task :compare do
      require 'benchmark/ips'
      Benchmark.ips do |b|
        hash = { 'thing' => 'gniht' }

        b.report 'has_key?' do
          hash.has_key? 'thing'
        end

        b.report '[]' do
          !!hash['thing']
        end
      end
    end
  end
end

current_tasks =  Rake.application.top_level_tasks
current_tasks << 'performance:benchmark:output:close'
Rake.application.instance_variable_set :@top_level_tasks, current_tasks
