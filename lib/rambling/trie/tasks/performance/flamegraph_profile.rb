require_relative 'performer'

module Performance
  class FlamegraphProfile < Performance::Performer
    def initialize filename
      @filename = filename
    end

    def do_perform iterations, params
      FileUtils.mkdir_p dirpath

      result = Flamegraph.generate filepath do
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
end
