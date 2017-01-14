require_relative 'performer'

module Performance
  class CallTreeProfile < Performance::Performer
    def initialize dirname
      @dirname = dirname
    end

    def do_perform iterations, params
      FileUtils.mkdir_p dirpath

      result = RubyProf.profile merge_fibers: true do
        params.each do |param|
          iterations.times do
            yield param
          end
        end
      end

      printer = RubyProf::CallTreePrinter.new result
      printer.print path: dirpath
    end

    private

    attr_reader :dirname

    def dirpath
      path 'reports', Rambling::Trie::VERSION, 'call-tree', time, dirname
    end
  end
end
