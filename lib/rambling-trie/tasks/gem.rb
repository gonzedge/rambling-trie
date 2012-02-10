namespace :gem do
  task :build do
    desc 'Build the rambling-trie gem'
    system 'gem build rambling-trie.gemspec'
  end

  task release: :build do
    desc 'Push the latest version of the rambling-trie gem'
    system "gem push rambling-trie-#{Rambling::Trie::VERSION}.gem"
  end

  task :version do
    desc 'Output the current rambling-trie version'
    puts "rambling-trie #{Rambling::Trie::VERSION}"
  end
end

