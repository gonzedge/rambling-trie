require_relative 'reporter'

module Performance
  module Reporters
    class MemoryProfile < Performance::Reporters::Reporter
      def initialize filename
        @filename = filename
      end

      def do_report iterations, params
        FileUtils.mkdir_p dirpath

        require 'memory_profiler'
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
end
