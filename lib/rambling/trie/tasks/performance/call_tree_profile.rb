class CallTreeProfile
  include Helpers::Path
  include Helpers::Time

  def initialize dirname
    @dirname = dirname
  end

  def perform iterations = 1, params = nil
    params = Array params
    params << nil unless params.any?

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
