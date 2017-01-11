namespace :performance do
  include Helpers::Path
  include Helpers::Time

  namespace :flamegraph do
    desc 'Output banner'
    task :banner do
      performance_report.start 'Flamegraph'
    end

    desc 'Generate flamegraph reports for creation'
    task creation: ['performance:directory', :banner] do
      output.puts 'Generating flamegraph reports for creation...'

      flamegraph = FlamegraphProfile.new 'creation'
      flamegraph.perform 1 do
        trie = Rambling::Trie.create dictionary
      end
    end

    desc 'Generate flamegraph reports for compression'
    task compression: ['performance:directory', :banner] do
      output.puts 'Generating flamegraph reports for compression...'

      trie = Rambling::Trie.load raw_trie_path

      flamegraph = FlamegraphProfile.new 'compression'
      flamegraph.perform 1 do
        trie.compress!
        nil
      end
    end

    namespace :serialization do
      desc 'Generate flamegraph reports for serialization (raw)'
      task raw: ['performance:directory', :banner] do
        output.puts 'Generating flamegraph reports for serialization (raw)...'

        flamegraph = FlamegraphProfile.new 'serialization-raw'
        flamegraph.perform 1 do
          trie = Rambling::Trie.load raw_trie_path
        end
      end

      desc 'Generate flamegraph reports for serialization (compressed)'
      task compressed: ['performance:directory', :banner] do
        output.puts 'Generating flamegraph reports for serialization (compressed)...'

        flamegraph = FlamegraphProfile.new 'serialization-compressed'
        flamegraph.perform 1 do
          trie = Rambling::Trie.load compressed_trie_path
        end
      end
    end

    desc 'Generate flamegraph reports for lookups'
    task lookups: ['performance:directory', :banner] do
      output.puts 'Generating flamegraph reports for lookups...'

      words = %w(hi help beautiful impressionism anthropological)

      tries.each do |trie|
        prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"

        flamegraph = FlamegraphProfile.new "#{prefix}-word"
        flamegraph.perform 1, words do |word|
          trie.word? word
        end
      end

      tries.each do |trie|
        prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
        flamegraph = FlamegraphProfile.new "#{prefix}-partial-word"
        flamegraph.perform 1, words do |word|
          trie.partial_word? word
        end
      end
    end

    desc 'Generate flamegraph reports for scans'
    task scans: ['performance:directory', :banner] do
      output.puts 'Generating flamegraph reports for scans...'

      words = %w(hi help beautiful impressionism anthropological)

      tries.each do |trie|
        prefix = "#{trie.compressed? ? 'compressed' : 'uncompressed'}-trie"
        flamegraph = FlamegraphProfile.new "#{prefix}-scan"
        flamegraph.perform 1, words do |word|
          trie.scan(word).size
        end
      end
    end

    desc 'Generate all flamegraph reports'
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
