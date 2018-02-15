require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

require 'rambling-trie'
require_relative 'tasks/performance'
require_relative 'tasks/serialization'
require_relative 'tasks/ips'

RSpec::Core::RakeTask.new :spec

task default: :spec
