require_relative '../../helpers/path'
require_relative '../../helpers/time'

namespace :performance do
  namespace :profile do
    include Helpers::Path
    include Helpers::Time

    def profile times, params, path
      params = Array params
      params << nil unless params.any?

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

    def generate_scans_call_tree
      puts 'Generating call tree profiling reports for scans...'

      puts "\nCall Tree profile for rambling-trie version #{Rambling::Trie::VERSION}"
      trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
      tries = [ trie, trie.clone.compress! ]

      words = {
        hi: 1_000,
        help: 10_000,
        beautiful: 100_000,
        impressionism: 200_000,
        anthropological: 200_000,
      }

      tries.each do |trie|
        filename = "profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-scan"
        path = path 'reports', Rambling::Trie::VERSION, 'call-tree', time.to_s, filename
        FileUtils.mkdir_p path

        words.each do |word, times|
          profile times, word, path do
            trie.scan word
          end
        end
      end

      puts 'Done'
    end

    namespace :call_tree do
      desc 'Generate call tree profiling reports for creation'
      task creation: ['performance:directory'] do
        puts 'Generating call tree profiling reports for creation...'
        puts "\nCall Tree profile for rambling-trie version #{Rambling::Trie::VERSION}"
        filename = "profile-new-trie"
        path = path 'reports', Rambling::Trie::VERSION, 'call-tree', time.to_s, filename
        FileUtils.mkdir_p path

        profile 5, nil, path do
          trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
        end
      end

      desc 'Generate call tree profiling reports for compression'
      task compression: ['performance:directory'] do
        puts 'Generating call tree profiling reports for compression...'
        puts "\nCall Tree profile for rambling-trie version #{Rambling::Trie::VERSION}"

        filename = "profile-compressed-trie"
        path = path 'reports', Rambling::Trie::VERSION, 'call-tree', time.to_s, filename
        FileUtils.mkdir_p path

        trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
        profile 5, nil, path do
          trie.clone.compress!
        end
      end

      desc 'Generate call tree profiling reports for lookups'
      task lookups: ['performance:directory'] do
        generate_lookups_call_tree
      end

      desc 'Generate call tree profiling reports for scans'
      task scans: ['performance:directory'] do
        generate_scans_call_tree
      end

      task all: [
        'performance:profile:call_tree:creation',
        'performance:profile:call_tree:compression',
        'performance:profile:call_tree:lookups',
        'performance:profile:call_tree:scans',
      ]
    end
  end
end
