class BenchmarkMeasurement
  def initialize output
    @output = output
  end

  def param_to_s param
    case param
    when Rambling::Trie::Container
      ''
    else
      param.to_s
    end
  end

  def perform times, params = nil
    params = Array params
    params << nil unless params.any?

    params.each do |param|
      output.print "#{times} iterations - #{param_to_s(param)}".ljust 40

      measure times, param do |param|
        yield param
      end
    end
  end

  private

  attr_reader :output

  def measure times, param = nil
    result = nil

    measure = Benchmark.measure do
      times.times do
        result = yield param
      end
    end

    output.puts "#{result}".ljust 10
    output.print ' ' * 30
    output.puts measure
  end
end
