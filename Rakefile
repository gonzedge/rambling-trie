# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

require 'rambling-trie'
require_relative 'tasks/performance'
require_relative 'tasks/serialization'
require_relative 'tasks/ips'

RSpec::Core::RakeTask.new :spec
RuboCop::RakeTask.new :rubocop

task default: :spec
