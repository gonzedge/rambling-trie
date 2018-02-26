# frozen_string_literal: true

require_relative '../helpers/path'

module Serialization
  class Regenerate
    include Helpers::Path

    def initialize dictionaries:, formats:
      @dictionaries = dictionaries
      @formats = formats
    end

    def execute
      dictionaries.each do |name|
        puts "Regenerating serialized dictionary '#{name}'... "

        tries(name).each do |trie|
          formats.each do |format|
            dump trie, filename(trie, name, format)
          end
        end

        puts 'DONE'
        puts
      end
    end

    private

    attr_reader :dictionaries, :formats

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

    def dump trie, filename
      puts "Serializing to '#{filename}'... "

      path = File.join tries_path, filename
      File.delete path if File.exist?(path)
      Rambling::Trie.dump trie, path
    end
  end
end
