require 'fileutils'
require 'benchmark'
require 'ruby-prof'
require 'memory_profiler'
require 'benchmark/ips'
require 'flamegraph'
require_relative 'performance/benchmark'
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

namespace :performance do
  desc 'Create report dir'
  task :directory do
    Performance::Directory.create
  end
end
