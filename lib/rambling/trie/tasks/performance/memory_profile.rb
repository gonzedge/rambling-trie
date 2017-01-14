require_relative 'performer'

module Performance
  class MemoryProfile < Performance::Performer
    def initialize filename
      @filename = filename
    end

    def do_perform iterations, params
      FileUtils.mkdir_p dirpath

      result = MemoryProfiler.report allow_files: 'lib/rambling/trie', ignore_files: 'lib/rambling/trie/tasks' do
        with_gc_stats "performing #{filename}" do
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
end
