require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'rambling-trie'
require 'rambling/trie/tasks/performance'

RSpec::Core::RakeTask.new(:spec)

task default: :spec
