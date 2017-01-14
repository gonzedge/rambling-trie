class MemoryProfile
  include Helpers::GC
  include Helpers::Path
  include Helpers::Time

  def initialize filename
    @filename = filename
  end

  def perform iterations = 1, params = nil
    params = Array params
    params << nil unless params.any?

    FileUtils.mkdir_p dirpath

    result = MemoryProfiler.report allow_files: 'lib/rambling/trie', ignore_files: 'lib/rambling/trie/tasks' do
      with_gc_stats do
        params.each do |param|
          iterations.times do
            yield param
          end
        end
      end
    end

    result.pretty_print to_file: filepath
  end

  private

  attr_reader :filename

  def dirpath
    path 'reports', Rambling::Trie::VERSION, 'memory', time
  end

  def filepath
    File.join dirpath, filename
  end
end
