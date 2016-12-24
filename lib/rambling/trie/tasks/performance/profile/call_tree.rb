require_relative '../../helpers/path'

namespace :performance do
  namespace :profile do
    def profile times, params, path
      result = RubyProf.profile merge_fibers: true do
        params.each do |param|
          times.times do
            yield param
          end
        end
      end

      printer = RubyProf::CallTreePrinter.new result
      printer.print path: path
    end

    def generate_lookups_call_tree
      puts 'Generating call tree profiling reports for lookups...'

      puts "\nCall Tree profile for rambling-trie version #{Rambling::Trie::VERSION}"
      trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
      tries = [ trie, trie.clone.compress! ]

      words = %w(hi help beautiful impressionism anthropological)
      time = Time.now.to_i

      tries.each do |trie|
        filename = "profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-word"
        path = path 'reports', Rambling::Trie::VERSION, 'call-tree', time.to_s, filename
        FileUtils.mkdir_p path

        profile 200_000, words, path do
          trie.word? word
        end

        filename = "profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-partial-word"
        path = path 'reports', Rambling::Trie::VERSION, 'call-tree', time.to_s, filename
        FileUtils.mkdir_p path

        profile 200_000, words, path do
          trie.partial_word? word
        end
      end

      puts 'Done'
    end

    namespace :call_tree do
      desc 'Generate application profiling reports for lookups'
      task :lookups do
        generate_lookups_call_tree
      end
    end
  end
end
