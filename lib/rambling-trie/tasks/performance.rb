require 'benchmark'

namespace :performance do
  def generate_report(filename = nil)
    output = filename.nil? ? $stdout : File.open(filename, 'w')
    words = ['hi', 'help', 'beautiful', 'impressionism', 'anthropological']

    trie = Rambling::Trie.new(get_path('assets', 'dictionaries', 'words_with_friends.txt'))

    output.puts "Report for rambling-trie version #{Rambling::Trie::VERSION}"
    output.puts '==> Uncompressed'

    words.each do |word|
      output.print word.ljust(15)
      output.puts Benchmark.measure { 200_000.times {trie.is_word?(word.clone) }}
    end

    return unless trie.respond_to?(:compress!)

    trie.compress!
    output.puts '==> Compressed'
    words.each do |word|
      output.print word.ljust(15)
      output.puts Benchmark.measure { 200_000.times {trie.is_word?(word.clone) }}
    end

    output.close
  end

  def get_path(*filename)
    File.join(File.dirname(__FILE__), '..', '..', '..', *filename)
  end

  task :report do
    puts 'Generating performance report...'
    generate_report
  end

  namespace :report do
    task :save do
      puts 'Generating performance report...'
      generate_report(get_path('reports', 'performance'))
      puts 'Report has been saved to reports/performance'
    end
  end
end
