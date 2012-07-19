require 'benchmark'

namespace :performance do
  def report(name, trie, output)
    words = ['hi', 'help', 'beautiful', 'impressionism', 'anthropological']
    methods = [:is_word?, :has_branch_for?]

    output.puts "==> #{name}"
    methods.each do |method|
      output.puts "`#{method}`:"
      words.each do |word|
        output.print "#{word} - #{trie.send(method, word)}".ljust 30
        output.puts Benchmark.measure { 200_000.times { trie.send method, word }}
      end
    end
  end

  def generate_report(filename = nil)
    output = filename.nil? ? $stdout : File.open(filename, 'a+')

    trie = Rambling::Trie.create get_path('assets', 'dictionaries', 'words_with_friends.txt')

    output.puts "\nReport for rambling-trie version #{Rambling::Trie::VERSION}"
    report 'Uncompressed', trie, output

    return unless trie.respond_to? :compress!

    trie.compress!
    report 'Compressed', trie, output

    output.close
  end

  def get_path(*filename)
    File.join File.dirname(__FILE__), '..', '..', '..', *filename
  end

  desc 'Generate performance report'
  task :report do
    puts 'Generating performance report...'
    generate_report
  end

  namespace :report do
    desc 'Generate performance report and append result to reports/performance'
    task :save do
      puts 'Generating performance report...'
      generate_report get_path('reports', 'performance')
      puts 'Report has been saved to reports/performance'
    end
  end

  desc 'Generate application profiling reports'
  task :profile do
    require 'ruby-prof'

    puts 'Generating profiling reports...'

    rambling_trie = Rambling::Trie.create get_path('assets', 'dictionaries', 'words_with_friends.txt')
    words = ['hi', 'help', 'beautiful', 'impressionism', 'anthropological']
    methods = [:has_branch_for?, :is_word?]
    tries = [lambda {rambling_trie.clone}, lambda {rambling_trie.clone.compress!}]

    methods.each do |method|
      tries.each do |trie_generator|
        trie = trie_generator.call
        result = RubyProf.profile do
          words.each do |word|
            200_000.times { trie.send method, word }
          end
        end

        File.open get_path('reports', "profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-#{method.to_s.sub(/\?/, '')}-#{Time.now.to_i}"), 'w' do |file|
          RubyProf::CallTreePrinter.new(result).print file
        end
      end
    end

    puts 'Done'
  end

  desc 'Generate CPU profiling reports'
  task :cpu_profile do
    require 'perftools'

    puts 'Generating cpu profiling reports...'

    rambling_trie = Rambling::Trie.create get_path('assets', 'dictionaries', 'words_with_friends.txt')
    words = ['hi', 'help', 'beautiful', 'impressionism', 'anthropological']
    methods = [:has_branch_for?, :is_word?]
    tries = [lambda {rambling_trie.clone}, lambda {rambling_trie.clone.compress!}]

    methods.each do |method|
      tries.each do |trie_generator|
        trie = trie_generator.call
        result = PerfTools::CpuProfiler.start get_path('reports', "cpu_profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-#{method.to_s.sub(/\?/, '')}-#{Time.now.to_i}") do
          words.each do |word|
            200_000.times { trie.send method, word }
          end
        end
      end
    end

    puts 'Done'
  end

  desc 'Generate profiling and performance reports'
  task all: [:profile, :report]
end
