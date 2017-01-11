namespace :performance do
  namespace :profile do
    include Helpers::Path
    include Helpers::Time
    include Helpers::Util

    namespace :call_tree do
      desc 'Output banner'
      task :banner do
        performance_report.start 'Call Tree profile'
      end

      desc 'Generate call tree profiling reports for creation'
      task creation: ['performance:directory', :banner] do
        output.puts 'Generating call tree profiling reports for creation...'

        call_tree_profile = CallTreeProfile.new 'creation'
        call_tree_profile.perform 5 do
          trie = Rambling::Trie.create dictionary
        end

        output.puts 'Done'
      end

      desc 'Generate call tree profiling reports for compression'
      task compression: ['performance:directory', :banner] do
        output.puts 'Generating call tree profiling reports for compression...'

        tries = []
        5.times { tries << Rambling::Trie.load(raw_trie_path) }

        call_tree_profile = CallTreeProfile.new 'compression'
        call_tree_profile.perform 5, tries do |trie|
          trie.compress!
          nil
        end

        output.puts 'Done'
      end

      namespace :serialization do
        desc 'Generate call tree profiling reports for serialization (raw)'
        task raw: ['performance:directory', :banner] do
          output.puts 'Generating call tree profiling reports for serialization (raw)...'

          call_tree_profile = CallTreeProfile.new 'serialization-raw'
          call_tree_profile.perform 5 do
            trie = Rambling::Trie.load raw_trie_path
          end

          output.puts 'Done'
        end

        desc 'Generate call tree profiling reports for serialization (compressed)'
        task compressed: ['performance:directory', :banner] do
          output.puts 'Generating call tree profiling reports for serialization (compressed)...'

          call_tree_profile = CallTreeProfile.new 'serialization-compressed'
          call_tree_profile.perform 5 do
            trie = Rambling::Trie.load compressed_trie_path
          end

          output.puts 'Done'
        end
      end

      desc 'Generate call tree profiling reports for lookups'
      task lookups: ['performance:directory', :banner] do
        output.puts 'Generating call tree profiling reports for lookups...'

        words = %w(hi help beautiful impressionism anthropological)

        tries.each do |trie|
          prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"

          call_tree_profile = CallTreeProfile.new "#{prefix}-word"
          call_tree_profile.perform 200_000, words do
            trie.word? word
          end
        end

        tries.each do |trie|
          prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"

          call_tree_profile = CallTreeProfile.new "#{prefix}-partial-word"
          call_tree_profile.perform 200_000, words do
            trie.partial_word? word
          end
        end

        output.puts 'Done'
      end

      desc 'Generate call tree profiling reports for scans'
      task scans: ['performance:directory', :banner] do
        output.puts 'Generating call tree profiling reports for scans...'

        words = {
          hi: 1_000,
          help: 100_000,
          beautiful: 100_000,
          impressionism: 200_000,
          anthropological: 200_000,
        }

        tries.each do |trie|
          prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"

          call_tree_profile = CallTreeProfile.new "#{prefix}-scan"

          words.each do |word, times|
            call_tree_profile.perform times, word.to_s do |word|
              trie.scan(word).size
            end
          end
        end

        output.puts 'Done'
      end

      desc 'Generate all call tree profiling reports'
      task all: [
        :creation,
        :compression,
        'serialization:raw',
        'serialization:compressed',
        :lookups,
        :scans,
      ]
    end
  end
end
