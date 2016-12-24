require_relative '../helpers/path'

namespace :performance do
  include Helpers::Path

  def banner output
    output.puts "\nBenchmark for rambling-trie version #{Rambling::Trie::VERSION}"
  end

  def measure times, param, output
    measure = Benchmark.measure do
      times.times do
        yield param
      end
    end
    output.puts measure
  end

  def perform_benchmark times, params, output
    params = Array params
    if params.any?
      params.each do |param|
        output.print "#{param}".ljust 30

        measure times, param, output do |param|
          yield param
        end
      end
    else
      measure times, nil, output do |param|
        yield param
      end
    end
  end

  def benchmark_lookups trie, output
    words = %w(hi help beautiful impressionism anthropological)

    output.puts 'word?:'
    perform_benchmark 200_000, words, output do |word|
      trie.word? word
    end

    output.puts 'partial_word?:'
    perform_benchmark 200_000, words, output do |word|
      trie.partial_word? word
    end
  end

  def with_file filename = nil
    output = filename.nil? ? IO.new(1) : File.open(filename, 'a+')

    yield output

    output.close
  end

  def generate_lookups_benchmark filename = nil
    with_file filename do |output|
      banner output

      trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
      [ trie, trie.clone.compress! ].each do |trie|
        output.puts "==> #{trie.compressed? ? 'Compressed' : 'Uncompressed'}"
        benchmark_lookups trie, output
      end
    end
  end

  def generate_scans_benchmark filename = nil
    with_file filename do |output|
      banner output

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
        output.puts "scan:"
        words.each do |word, times|
          perform_benchmark times, word.to_s, output do |word|
            trie.scan word
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
        puts 'Generating performance benchmark report...'
        generate_lookups_benchmark path('reports', Rambling::Trie::VERSION, 'benchmark')
        puts "Benchmarks have been saved to reports/#{Rambling::Trie::VERSION}/benchmark-lookups"
      end
    end

    task :creation do
      with_file do |output|
        banner output
        output.puts '==> Creation'

        perform_benchmark '`Rambling::Trie.create`', 5, [], output do
          trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
        end
      end
    end

    task :compression do
      with_file do |output|
        banner output
        output.puts '==> Compression'

        trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
        perform_benchmark '`compress!`', 5, nil, output do
          trie.clone.compress!
        end
      end
    end

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
