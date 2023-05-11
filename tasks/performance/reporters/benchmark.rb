# frozen_string_literal: true

require 'benchmark'
require_relative 'reporter'

module Performance
  module Reporters
    class Benchmark < Performance::Reporters::Reporter
      def initialize _ = nil, output = $stdout.dup
        super()
        @output = output
      end

      def do_report iterations, params
        params.each do |param|
          output.print "#{iterations} iterations - #{param}".ljust 40

          measure iterations, param do |_|
            yield param
          end
        end
      end

      private

      attr_reader :output

      def measure iterations, param
        result = nil

        require 'benchmark'
        measure = ::Benchmark.measure do
          iterations.times { result = yield param }
        end

        output.puts result.to_s.ljust 10
        output.print ' ' * 30
        output.puts measure
      end
    end
  end
end
