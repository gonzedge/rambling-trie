require_relative '../../helpers/path'

namespace :performance do
  namespace :profile do
    include Helpers::Path

    def with_gc_stats &block
      puts "Live objects before - #{GC.stat[:heap_live_slots]}"
      block.call
      puts "Live objects after  - #{GC.stat[:heap_live_slots]}"
    end

    def memory_profile name, &block
      puts
      puts name

      MemoryProfiler.report allow_files: 'lib/rambling/trie', ignore_files: 'tasks/performance' do
        block.call
      end.pretty_print to_file: path('reports', Rambling::Trie::VERSION, name)
    end

    desc 'Generate memory profiling report'
    task memory: ['performance:directory'] do
      puts 'Generating memory profiling reports...'

      trie = nil
      dictionary = path 'assets', 'dictionaries', 'words_with_friends.txt'
      time = Time.now.to_i

      memory_profile "#{time}-memory-profile-new-trie" do
        with_gc_stats { trie = Rambling::Trie.create dictionary }
      end

      words = %w(hi help beautiful impressionism anthropological)
      methods = [:word?, :partial_word?]

      # memory_profile "#{time}-memory-profile-searching-uncompressed-trie" do
      #   with_gc_stats do
      #     methods.each do |method|
      #       words.each do |word|
      #         200_000.times { trie.send method, word }
      #       end
      #     end
      #   end
      # end

      memory_profile "#{time}-memory-profile-compressed-trie" do
        with_gc_stats { trie.compress! }
      end

      # memory_profile "#{time}-memory-profile-searching-compressed-trie" do
      #   with_gc_stats do
      #     methods.each do |method|
      #       words.each do |word|
      #         200_000.times { trie.send method, word }
      #       end
      #     end
      #   end
      # end

      memory_profile "#{time}-memory-profile-trie-and-compress" do
        with_gc_stats { trie = Rambling::Trie.create dictionary }
        with_gc_stats { trie.compress! }
      end

      memory_profile "#{time}-memory-profile-trie-gc" do
        with_gc_stats { trie = Rambling::Trie.create dictionary }
        with_gc_stats { trie.compress! }
        with_gc_stats { GC.start }
      end

      puts 'End'
    end

  end
end
