# frozen_string_literal: true

module Helpers
  module GC
    def with_gc_stats name = nil
      puts "Live objects before #{name} - #{::GC.stat[:heap_live_slots]}"
      yield
      puts "Live objects after #{name}  - #{::GC.stat[:heap_live_slots]}"
    end
  end
end
