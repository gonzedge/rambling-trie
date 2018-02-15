require 'fileutils'
require 'benchmark'
require 'ruby-prof'
require 'memory_profiler'
require 'benchmark/ips'
require 'flamegraph'

%w{
  configuration directory report task
}.each do |filename|
  require_relative File.join('performance', filename)
end

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
