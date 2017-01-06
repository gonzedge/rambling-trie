namespace :performance do
  include Helpers::Path
  include Helpers::Time

  def performance_report
    @performance_report ||= PerformanceReport.new
  end

  def output
    performance_report.output
  end

  class FlamegraphProfile
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

  namespace :flamegraph do
    desc 'Output banner'
    task :banner do
      performance_report.start 'Flamegraph'
    end

    desc 'Generate flamegraph reports for creation'
    task creation: ['performance:directory', :banner] do
      output.puts 'Generating flamegraph reports for creation...'

      flamegraph = FlamegraphProfile.new 'new-trie'
      flamegraph.perform 1 do
        trie = Rambling::Trie.create dictionary
      end
    end

    desc 'Generate flamegraph reports for compression'
    task compression: ['performance:directory', :banner] do
      output.puts 'Generating flamegraph reports for compression...'

      tries = []
      1.times { tries << Rambling::Trie.create(dictionary) }

      flamegraph = FlamegraphProfile.new 'compressed-trie'
      flamegraph.perform 1, tries do |trie|
        trie.compress!
        nil
      end
    end

    desc 'Generate all flamegraph reports'
    task all: [
      :creation,
      :compression,
    ]
  end
end
