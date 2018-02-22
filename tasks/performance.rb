# frozen_string_literal: true

require 'fileutils'

%w(configuration directory report task).each do |filename|
  require_relative File.join('performance', filename)
end

task :performance, %i(type method) => 'performance:directory' do |_, args|
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
