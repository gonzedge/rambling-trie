require 'fileutils'
require_relative '../helpers/path'

namespace :performance do
  desc 'Create report dir'
  task :directory do
    include Helpers::Path
    FileUtils.mkdir_p path('reports', Rambling::Trie::VERSION)
  end
end
