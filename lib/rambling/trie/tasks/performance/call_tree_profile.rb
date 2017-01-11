class CallTreeProfile
  include Helpers::Path
  include Helpers::Time

  def initialize dirname
    @dirname = dirname
  end

  def perform times, params = nil
    params = Array params
    params << nil unless params.any?

    result = RubyProf.profile merge_fibers: true do
      params.each do |param|
        times.times do
          yield param
        end
      end
    end

    path = path 'reports', Rambling::Trie::VERSION, 'call-tree', time, dirname
    FileUtils.mkdir_p path
    printer = RubyProf::CallTreePrinter.new result
    printer.print path: path
  end

  private

  attr_reader :dirname
end
