require_relative '../helpers/path'

namespace :performance do
  include Helpers::Path

  class BenchmarkMeasurement
    def initialize output
      @output = output
    end

    def perform times, params = nil
      params = Array params
      params << nil unless params.any?

      params.each do |param|
        output.print "#{param}".ljust 20

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

  def with_file filename = nil
    output = filename.nil? ? IO.new(1) : File.open(filename, 'a+')

    yield output

    output.close
  end

  def generate_lookups_benchmark filename = nil
    with_file filename do |output|
      measure = BenchmarkMeasurement.new output
      measure.banner

      trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
      [ trie, trie.clone.compress! ].each do |trie|
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
  end

  def generate_scans_benchmark filename = nil
    with_file filename do |output|
      measure = BenchmarkMeasurement.new output
      measure.banner

      words = {
        hi: 1_000,
        help: 10_000,
        beautiful: 100_000,
        impressionism: 200_000,
        anthropological: 200_000,
      }
      trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')

      [ trie, trie.clone.compress! ].each do |trie|
        output.puts "==> #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
        output.puts "`scan`"
        words.each do |word, times|
          measure.perform times, word.to_s do |word|
            trie.scan(word).size
          end
        end
      end
    end
  end

  namespace :benchmark do
    desc 'Generate lookups performance benchmark report'
    task :lookups do
      generate_lookups_benchmark
    end

    desc 'Generate scans performance benchmark report'
    task :scans do
      generate_scans_benchmark
    end

    namespace :lookups do
      desc 'Generate performance benchmark report store results in reports/'
      task save: ['performance:directory'] do
        puts 'Generating performance benchmark report for lookups...'
        generate_lookups_benchmark path('reports', Rambling::Trie::VERSION, 'benchmark')
        puts "Benchmarks have been saved to reports/#{Rambling::Trie::VERSION}/benchmark"
      end
    end

    task :creation do
      with_file do |output|
        measure = BenchmarkMeasurement.new output
        measure.banner

        output.puts '==> Creation'
        output.puts '`Rambling::Trie.create`'
        measure.perform 5 do
          trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
        end
      end
    end

    task :compression do
      with_file do |output|
        measure = BenchmarkMeasurement.new output
        measure.banner

        output.puts '==> Compression'
        output.puts '`compress!`'

        trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
        measure.perform 5 do
          trie.clone.compress!
        end
      end
    end

    task all: [
      'performance:benchmark:creation',
      'performance:benchmark:compression',
      'performance:benchmark:lookups',
      'performance:benchmark:scans',
    ]

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
