require_relative 'helpers/path'

namespace :serialization do
  def dump trie, path
    File.delete path if File.exist?(path)
    Rambling::Trie.dump trie, path
  end

  desc 'Regenerate serialized tries in assets/'
  task :regenerate do
    include Helpers::Path

    dictionaries = [
      'espanol',
      'words_with_friends',
    ]

    formats = [
      'marshal',
      'marshal.zip',
    ]

    types = {
      false => 'raw',
      true => 'compressed',
    }

    dictionaries.each do |name|
      in_path = path 'assets', 'dictionaries', "#{name}.txt"
      puts "Regenerating serialized dictionary '#{name}'... "

      tries = [
        Rambling::Trie.create(in_path),
        Rambling::Trie.create(in_path).compress!,
      ]

      tries.each do |trie|
        formats.each do |format|
          filename = "#{name}_#{types[trie.compressed?]}.#{format}"
          path = path 'assets', 'tries', filename

          puts "Serializing to '#{filename}'... "

          dump trie, path
        end
      end

      puts 'DONE'
      puts
    end
  end
end
