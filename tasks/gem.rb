# frozen_string_literal: true

namespace :gem do
  desc 'Build the rambling-trie gem'
  task :build do
    system 'gem build rambling-trie.gemspec'
  end

  desc 'Push the latest version of the rambling-trie gem'
  task release: :build do
    system "gem push rambling-trie-#{Rambling::Trie::VERSION}.gem"
  end

  desc 'Output the current rambling-trie version'
  task :version do
    puts "rambling-trie #{Rambling::Trie::VERSION}"
  end
end
