namespace :performance do
  include Helpers::Path
  include Helpers::Time

  def generate times, params, path
    params = Array params
    params << nil unless params.any?

    result = Flamegraph.generate path do
      params.each do |param|
        times.times do
          yield param
        end
      end
    end
  end

  namespace :flamegraph do
    desc 'Generate flamegraph reports for creation'
    task creation: ['performance:directory'] do
      puts 'Generating flamegraph reports for creation...'
      puts "\nFlamegraph for rambling-trie version #{Rambling::Trie::VERSION}"
      directory = path 'reports', Rambling::Trie::VERSION, 'flamegraph', time
      FileUtils.mkdir_p directory

      filename = 'new-trie.html'
      path = File.join directory, filename

      generate 1, nil, path do
        trie = Rambling::Trie.create dictionary
      end
    end

    desc 'Generate flamegraph reports for compression'
    task compression: ['performance:directory'] do
      puts 'Generating flamegraph reports for compression...'
      puts "\nFlamegraph for rambling-trie version #{Rambling::Trie::VERSION}"

      directory = path 'reports', Rambling::Trie::VERSION, 'flamegraph', time
      FileUtils.mkdir_p directory

      filename = 'compressed-trie.html'
      path = File.join directory, filename

      tries = []
      1.times { tries << Rambling::Trie.create(dictionary) }

      generate 1, tries, path do |trie|
        trie.compress!
        nil
      end
    end
  end
end
