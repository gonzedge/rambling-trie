
namespace :performance do
  include Helpers::Path

  def benchmark name, trie, output
    words = %w(hi help beautiful impressionism anthropological)
    methods = [:word?, :partial_word?]

    output.puts "==> #{name}"
    methods.each do |method|
      output.puts "`#{method}`:"
      words.each do |word|
        output.print "#{word} - #{trie.send method, word}".ljust 30
        output.puts Benchmark.measure { 200_000.times { trie.send method, word }}
      end
    end
  end

  def generate_benchmark filename = nil
    output = filename.nil? ? $stdout : File.open(filename, 'a+')

    output.puts "\nBenchmark for rambling-trie version #{Rambling::Trie::VERSION}"

    trie = nil
    measure = Benchmark.measure { trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt') }

    if ENV['profile_creation']
      output.puts '==> Creation'
      output.print 'Rambling::Trie.create'.ljust 30
      output.puts measure
    end

    benchmark 'Uncompressed', trie, output

    return unless trie.respond_to? :compress!

    trie.compress!
    benchmark 'Compressed', trie, output

    output.close
  end

  desc 'Generate performance benchmark report'
  task :benchmark do
    puts 'Generating performance benchmark report...'
    generate_benchmark
  end

  namespace :benchmark do
    desc 'Generate performance benchmark report store results in reports/'
    task save: ['performance:directory'] do
      puts 'Generating performance benchmark report...'
      generate_benchmark path('reports', 'performance')
      puts 'Benchmarks have been saved to reports/'
    end
  end
end
