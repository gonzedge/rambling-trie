# frozen_string_literal: true

require_relative 'helpers/path'

namespace :serialization do
  desc 'Regenerate serialized tries in assets/'
  task :regenerate do
    include Helpers::Path

    dictionaries = %w(espanol words_with_friends)
    formats = %w(marshal marshal.zip)

    dump_dictionaries dictionaries, formats
  end
end

def dump_dictionaries dictionaries, formats
  dictionaries.each do |name|
    tries(name).each do |trie|
      formats.each do |format|
        dump_trie trie, name, format
      end
    end

    puts 'DONE'
    puts
  end
end

def tries name
  input_path = path 'assets', 'dictionaries', "#{name}.txt"
  puts "Regenerating serialized dictionary '#{name}'... "

  [
    Rambling::Trie.create(input_path),
    Rambling::Trie.create(input_path).compress!,
  ]
end

def dump_trie trie, name, format
  filename = "#{name}_#{trie.compressed? ? 'compressed' : 'raw'}.#{format}"

  puts "Serializing to '#{filename}'... "

  path = path 'assets', 'tries', filename
  dump trie, path
end

def dump trie, path
  File.delete path if File.exist?(path)
  Rambling::Trie.dump trie, path
end
