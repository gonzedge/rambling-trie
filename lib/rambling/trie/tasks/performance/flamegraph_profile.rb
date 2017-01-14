class FlamegraphProfile
  include Helpers::Path
  include Helpers::Time

  def initialize filename
    @filename = filename
  end

  def perform iterations = 1, params = nil
    params = Array params
    params << nil unless params.any?

    FileUtils.mkdir_p dirpath

    result = Flamegraph.generate path do
      params.each do |param|
        iterations.times do
          yield param
        end
      end
    end
  end

  private

  attr_reader :filename

  def dirpath
    path 'reports', Rambling::Trie::VERSION, 'flamegraph', time
  end

  def filepath
    File.join dirpath, "#{filename}.html"
  end
end
