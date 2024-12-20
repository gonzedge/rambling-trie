# frozen_string_literal: true

module Helpers
  module GarbageCollection
    def with_gc_stats name = nil
      puts "Live objects before #{name} - #{::GC.stat[:heap_live_slots]}"
      yield
      puts "Live objects after #{name}  - #{::GC.stat[:heap_live_slots]}"
    end

    def without_gc
      ::GC.start
      ::GC.disable
      yield
      ::GC.enable
    end
  end
end
