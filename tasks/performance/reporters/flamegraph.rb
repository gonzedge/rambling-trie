# frozen_string_literal: true

require_relative 'reporter'

module Performance
  module Reporters
    class Flamegraph < Performance::Reporters::Reporter
      def initialize filename
        @filename = filename
      end

      def do_report iterations, params
        FileUtils.mkdir_p dirpath

        require 'flamegraph'
        ::Flamegraph.generate filepath do
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
end
