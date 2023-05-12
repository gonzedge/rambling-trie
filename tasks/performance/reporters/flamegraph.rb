# frozen_string_literal: true

require_relative 'reporter'

module Performance
  module Reporters
    class Flamegraph < Performance::Reporters::Reporter
      def initialize filename
        super()
        @filename = filename
      end

      def do_report iterations, params
        FileUtils.mkdir_p dirpath

        require 'flamegraph'
        ::Flamegraph.generate filepath do
          params.each { |p| iterations.times { yield p } }
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
end
