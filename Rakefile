# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'reek/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'steep/rake_task'
require 'yard'

require 'rambling-trie'
require_relative 'tasks/performance'
require_relative 'tasks/serialization'
require_relative 'tasks/ips'

RSpec::Core::RakeTask.new :spec
Reek::Rake::Task.new :reek
RuboCop::RakeTask.new :rubocop
Steep::RakeTask.new :steep
YARD::Rake::YardocTask.new :yard

task default: :spec
