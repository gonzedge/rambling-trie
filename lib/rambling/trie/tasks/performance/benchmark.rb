require_relative '../helpers/path'

namespace :performance do
  include Helpers::Path

  def measure times, param, output
    measure = Benchmark.measure do
      times.times do
        yield param
      end
    end
    output.puts measure
  end

  def perform_benchmark name, times, params, output
    output.puts "`#{name}`:"

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

  def benchmark_lookups name, trie, output
    words = %w(hi help beautiful impressionism anthropological)

    output.puts "==> #{name}"
    perform_benchmark 'word?', 200_000, words, output do |word|
      trie.word? word
    end

    perform_benchmark 'partial_word?', 200_000, words, output do |word|
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
      output.puts "\nBenchmark for rambling-trie version #{Rambling::Trie::VERSION}"

      trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
      benchmark_lookups 'Uncompressed', trie, output

      trie.compress!
      benchmark_lookups 'Compressed', trie, output
    end
  end

  namespace :benchmark do
    desc 'Generate performance benchmark report'
    task :lookups do
      puts 'Generating performance benchmark report...'
      generate_lookups_benchmark
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
        output.puts "\nBenchmark for rambling-trie version #{Rambling::Trie::VERSION}"
        output.puts '==> Creation'

        perform_benchmark '`Rambling::Trie.create`', 5, [], output do
          trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
        end
      end
    end

    task :compression do
      with_file do |output|
        output.puts "\nBenchmark for rambling-trie version #{Rambling::Trie::VERSION}"
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
