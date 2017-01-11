class MemoryProfile
  include Helpers::GC

  def initialize name
    @name = name
  end

  def perform
    result = MemoryProfiler.report allow_files: 'lib/rambling/trie', ignore_files: 'lib/rambling/trie/tasks' do
      with_gc_stats do
        yield
      end
    end

    dir = path 'reports', Rambling::Trie::VERSION, 'memory', time
    FileUtils.mkdir_p dir
    result.pretty_print to_file: File.join(dir, name)
  end

  private

  attr_reader :name
end
