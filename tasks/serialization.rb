# frozen_string_literal: true

require_relative 'helpers/path'

namespace :serialization do
  desc 'Regenerate serialized tries'
  task regenerate: %i(serialization:directory) do
    include Helpers::Path

    dictionaries = %w(espanol words_with_friends)
    formats = %w(marshal marshal.zip)

    dump_dictionaries dictionaries, formats
  end

  desc 'Create serialization directories'
  task :directory do
    include Helpers::Path

    FileUtils.mkdir_p tries_path
  end
end

def dump_dictionaries dictionaries, formats
  dictionaries.each do |name|
    puts "Regenerating serialized dictionary '#{name}'... "

    tries(name).each do |trie|
      formats.each do |format|
        dump_trie trie, filename(trie, name, format)
      end
    end

    puts 'DONE'
    puts
  end
end

def tries name
  input_path = File.join dictionaries_path, "#{name}.txt"

  [
    Rambling::Trie.create(input_path),
    Rambling::Trie.create(input_path).compress!,
  ]
end

def filename trie, name, format
  type = trie.compressed? ? 'compressed' : 'raw'
  "#{name}_#{type}.#{format}"
end

def dump_trie trie, filename
  puts "Serializing to '#{filename}'... "

  path = File.join tries_path, filename
  dump trie, path
end

def dump trie, path
  File.delete path if File.exist?(path)
  Rambling::Trie.dump trie, path
end
