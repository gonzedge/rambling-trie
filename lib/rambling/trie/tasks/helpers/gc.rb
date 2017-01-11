module Helpers
  module GC
    def with_gc_stats
      output.puts "Live objects before - #{::GC.stat[:heap_live_slots]}"
      yield
      output.puts "Live objects after  - #{::GC.stat[:heap_live_slots]}"
    end
  end
end
