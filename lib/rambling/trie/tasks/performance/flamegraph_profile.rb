class FlamegraphProfile
  include Helpers::Path
  include Helpers::Time

  def initialize filename
    @filename = filename
  end

  def perform times, params = nil
    params = Array params
    params << nil unless params.any?

    dirname = path 'reports', Rambling::Trie::VERSION, 'flamegraph', time
    FileUtils.mkdir_p dirname
    path = File.join dirname, "#{filename}.html"

    result = Flamegraph.generate path do
      params.each do |param|
        times.times do
          yield param
        end
      end
    end
  end

  private

  attr_reader :filename
end
