# frozen_string_literal: true

require_relative 'reporter'

module Performance
  module Reporters
    class CallTreeProfile < Performance::Reporters::Reporter
      def initialize dirname
        super()
        @dirname = dirname
      end

      def do_report iterations, params
        FileUtils.mkdir_p dirpath

        require 'ruby-prof'
        profile = RubyProf::Profile.new
        profile.profile { params.each { |p| iterations.times { yield p } } }
        profile.merge!

        printer = RubyProf::CallTreePrinter.new profile
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
