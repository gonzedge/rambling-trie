require 'fileutils'
require 'benchmark'
require 'ruby-prof'
require 'memory_profiler'
require 'benchmark/ips'
require 'flamegraph'
require_relative 'helpers/gc'
require_relative 'helpers/path'
require_relative 'helpers/time'
require_relative 'helpers/trie'
require_relative 'performance/benchmark_measurement'
require_relative 'performance/call_tree_profile'
require_relative 'performance/configuration'
require_relative 'performance/directory'
require_relative 'performance/flamegraph_profile'
require_relative 'performance/memory_profile'
require_relative 'performance/report'
require_relative 'performance/task'

task :performance, [:type, :method] => 'performance:directory' do |t, args|
  configuration = Performance::Configuration.new
  task = Performance::Task.new configuration
  task.run args
end
