require 'fileutils'

%w{
  configuration directory report task
}.each do |filename|
  require_relative File.join('performance', filename)
end

task :performance, [:type, :method] => 'performance:directory' do |t, args|
  require 'benchmark/ips'

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
