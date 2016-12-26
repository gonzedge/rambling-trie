require_relative '../helpers/path'

namespace :performance do
  include Helpers::Path

  class BenchmarkReport
    attr_reader :output

    def initialize output
      @output = output
    end

    def finish
      output.close
    end
  end

  class BenchmarkMeasurement
    def initialize output
      @output = output
    end

    def param_to_s param
      case param
      when Rambling::Trie::Container
        ''
      else
        param.to_s
      end
    end

    def perform times, params = nil
      params = Array params
      params << nil unless params.any?

      params.each do |param|
        output.print param_to_s(param).ljust 20

        measure times, param do |param|
          yield param
        end
      end
    end

    def banner
      output.puts "\nBenchmark for rambling-trie version #{Rambling::Trie::VERSION}"
    end

    private

    attr_reader :output

    def measure times, param = nil
      result = nil

      measure = Benchmark.measure do
        times.times do
          result = yield param
        end
      end

      output.print "#{result}".ljust 10
      output.puts measure
    end
  end

  def benchmark_report= benchmark_report
    @benchmark_report = benchmark_report
  end

  def benchmark_report
    Rake::Task['performance:benchmark:output:stdout'].invoke unless @benchmark_report

    @benchmark_report
  end

  def output
    benchmark_report.output
  end

  def generate_lookups_benchmark filename = nil
    measure = BenchmarkMeasurement.new output
    measure.banner

    trie = Rambling::Trie.create dictionary
    compressed_trie = Rambling::Trie.create(dictionary).compress!
    [ trie, compressed_trie ].each do |trie|
      output.puts "==> #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
      words = %w(hi help beautiful impressionism anthropological)

      output.puts '`word?`'
      measure.perform 200_000, words do |word|
        trie.word? word
      end

      output.puts '`partial_word?`'
      measure.perform 200_000, words do |word|
        trie.partial_word? word
      end
    end
  end

  def generate_scans_benchmark filename = nil
    measure = BenchmarkMeasurement.new output
    measure.banner

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
      output.puts "==> #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
      output.puts "`scan`"
      words.each do |word, times|
        measure.perform times, word.to_s do |word|
          trie.scan(word).size
        end
      end
    end
  end

  namespace :benchmark do
    namespace :output do
      desc 'Set task reporting output to stdout'
      task :stdout do
        self.benchmark_report = BenchmarkReport.new IO.new(1)
      end

      desc 'Set task reporting output to file'
      task file: ['performance:directory'] do
        path = path 'reports', Rambling::Trie::VERSION, 'benchmark'
        file = File.open path, 'a+'
        self.benchmark_report = BenchmarkReport.new file
      end

      desc 'Close output stream'
      task :close do
        benchmark_report.finish unless benchmark_report.nil?
      end
    end

    desc 'Generate lookups performance benchmark report'
    task :lookups do
      generate_lookups_benchmark
    end

    desc 'Generate scans performance benchmark report'
    task :scans do
      generate_scans_benchmark
    end

    desc 'Generate creation performance benchmark report'
    task :creation do
      measure = BenchmarkMeasurement.new output
      measure.banner

      output.puts '==> Creation'
      output.puts '`Rambling::Trie.create`'
      measure.perform 5 do
        trie = Rambling::Trie.create dictionary
        nil
      end
    end

    desc 'Generate compression performance benchmark report'
    task :compression do
      measure = BenchmarkMeasurement.new output
      measure.banner

      output.puts '==> Compression'
      output.puts '`compress!`'

      tries = []
      5.times { tries << Rambling::Trie.create(dictionary) }

      measure.perform 5, tries do |trie|
        trie.compress!
        nil
      end
    end

    desc 'Generate all performance benchmark reports'
    task all: [
      'creation',
      'compression',
      'lookups',
      'scans',
    ]

    namespace :all do
      desc "Generate and store performance benchmark report in reports/#{Rambling::Trie::VERSION}"
      task save: [
        'output:file',
        'all'
      ]
    end

    desc 'Compare ips for different implementations (changes over time)'
    task :compare do
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
