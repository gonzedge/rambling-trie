module Helpers
  module GC
    def with_gc_stats
      puts "Live objects before - #{::GC.stat[:heap_live_slots]}"
      yield
      puts "Live objects after  - #{::GC.stat[:heap_live_slots]}"
    end
  end
end
