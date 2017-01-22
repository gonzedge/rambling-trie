require_relative 'benchmark_tasks'
require_relative 'call_tree_tasks'
require_relative 'flamegraph_tasks'
require_relative 'memory_tasks'

module Performance
  class Configuration
    include Performance::BenchmarkTasks
    include Performance::CallTreeTasks
    include Performance::MemoryTasks
    include Performance::FlamegraphTasks

    def get type, method
      type ||= 'all'
      method ||= 'all'

      if type == 'all'
        get_all_types method
      elsif method == 'all'
        get_all_methods type
      else
        tasks[type][method]
      end
    end

    def get_all_types method
      lambda do |output|
        tasks.keys.each do |type|
          output.puts
          output.puts "Running #{type} tasks..."
          get(type, method).call output
        end
      end
    end

    def get_all_methods type
      lambda do |output|
        tasks[type].each do |method, task|
          task.call output
        end
      end
    end

    def tasks
      {
        'benchmark' => benchmark_tasks,
        'call_tree' => call_tree_tasks,
        'memory' => memory_tasks,
        'flamegraph' => flamegraph_tasks
      }
    end
  end
end
