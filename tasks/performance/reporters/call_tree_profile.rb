# frozen_string_literal: true

require_relative 'reporter'

module Performance
  module Reporters
    class CallTreeProfile < Performance::Reporters::Reporter
      def initialize dirname
        @dirname = dirname
      end

      def do_report iterations, params
        FileUtils.mkdir_p dirpath

        require 'ruby-prof'
        result = RubyProf.profile merge_fibers: true do
          params.each do |param|
            iterations.times do
              yield param
            end
          end
        end

        printer = RubyProf::CallTreePrinter.new result
        printer.print path: dirpath
      end

      private

      attr_reader :dirname

      def dirpath
        path 'reports', Rambling::Trie::VERSION, 'call-tree', time, dirname
      end
    end
  end
end
