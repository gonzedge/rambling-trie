class BenchmarkMeasurement
  def initialize output
    @output = output
  end

  def perform iterations = 1, params = nil
    params = Array params
    params << nil unless params.any?

    params.each do |param|
      output.print "#{iterations} iterations - #{param.to_s}".ljust 40

      measure iterations, param do |param|
        yield param
      end
    end
  end

  private

  attr_reader :output

  def measure iterations, param = nil
    result = nil

    measure = Benchmark.measure do
      iterations.times do
        result = yield param
      end
    end

    output.puts "#{result}".ljust 10
    output.print ' ' * 30
    output.puts measure
  end
end
