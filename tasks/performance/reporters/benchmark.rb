require 'benchmark'
require_relative 'reporter'

module Performance
  module Reporters
    class Benchmark < Performance::Reporters::Reporter
      def initialize filename = nil, output = $stdout.dup
        @output = output
      end

      def do_report iterations, params
        params.each do |param|
          output.print "#{iterations} iterations - #{param.to_s}".ljust 40

          measure iterations, param do |param|
            yield param
          end
        end
      end

      private

      attr_reader :output

      def measure iterations, param
        result = nil

        measure = ::Benchmark.measure do
          iterations.times do
            result = yield param
          end
        end

        output.puts "#{result}".ljust 10
        output.print ' ' * 30
        output.puts measure
      end
    end
  end
end
