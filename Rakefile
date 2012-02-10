require 'rspec/core/rake_task'
require 'rambling-trie/version'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :gem do
  task :build do
    system 'gem build rambling-trie.gemspec'
  end

  task release: :build do
    system "gem build rambling-trie-#{Rambling::Trie::VERSION}.gem"
  end

  task :version do
    puts "rambling-trie #{Rambling::Trie::VERSION}"
  end
end
