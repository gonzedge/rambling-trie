# frozen_string_literal: true

module Performance
  class Task
    attr_reader :configuration, :output

    def initialize configuration, output = $stdout.dup
      @configuration = configuration
      @output = output
    end

    def run type: 'all', method: 'all'
      task = configuration.get type, method

      output.puts
      output.puts "#{name type} for rambling-trie version #{version}"
      output.puts

      if task
        task.call output
      else
        Rake::Task["performance:#{type}:#{method}"].invoke
      end
    end

    def name type
      names[type]
    end

    def names
      {
        'all' => 'All performance tasks',
        'benchmark' => 'Benchmarks',
        'call_tree' => 'Call Tree profile',
        'memory' => 'Memory profile',
        'flamegraph' => 'Flamegraphs',
      }
    end

    private

    def version
      Rambling::Trie::VERSION
    end
  end
end
