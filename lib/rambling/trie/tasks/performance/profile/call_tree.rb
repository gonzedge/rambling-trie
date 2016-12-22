require_relative '../../helpers/path'

namespace :performance do
  namespace :profile do
    desc 'Generate application profiling reports'
    task :call_tree do
      puts 'Generating call tree profiling reports...'

      trie = Rambling::Trie.create path('assets', 'dictionaries', 'words_with_friends.txt')
      words = %w(hi help beautiful impressionism anthropological)
      methods = [:word?, :partial_word?]
      tries = [lambda {trie.clone}, lambda {trie.clone.compress!}]
      time = Time.now.to_i

      methods.each do |method|
        tries.each do |trie_generator|
          trie = trie_generator.call
          result = RubyProf.profile merge_fibers: true do
            words.each do |word|
              200_000.times { trie.send method, word }
            end
          end

          path = path('reports', Rambling::Trie::VERSION, "#{time}-profile-#{trie.compressed? ? 'compressed' : 'uncompressed'}-#{method.to_s.sub(/\?/, '')}")

          FileUtils.mkdir_p path
          printer = RubyProf::CallTreePrinter.new result
          printer.print path: path
        end
      end

      puts 'Done'
    end
  end
end
