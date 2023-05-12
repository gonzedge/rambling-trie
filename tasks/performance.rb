# frozen_string_literal: true

require 'fileutils'

%w(configuration directory report task).each do |filename|
  require_relative File.join('performance', filename)
end

arg_names = %i(type method)
dependencies = %i(serialization:regenerate performance:directory)

task :performance, arg_names => dependencies do |_, args|
  configuration = Performance::Configuration.new
  task = Performance::Task.new configuration
  task.run(**args)
end

namespace :performance do
  desc 'Create report dir'
  task :directory do
    Performance::Directory.create
  end
end
