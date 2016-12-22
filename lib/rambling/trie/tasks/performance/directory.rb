require 'fileutils'
require_relative '../helpers/path'

namespace :performance do
  include Helpers::Path

  desc 'Create report dir'
  task :directory do
    FileUtils.mkdir_p path('reports', Rambling::Trie::VERSION)
  end
end
