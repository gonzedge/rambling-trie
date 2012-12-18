%w{
  invalid_operation children_hash_deferer compressor
  branches enumerable node root version
}.map { |file| File.join 'rambling', 'trie', file }.each &method(:require)

# General namespace for all Rambling gems.
module Rambling
  # Entry point for rambling-trie API.
  module Trie
    class << self
      # Creates a new Trie. Entry point for the Rambling::Trie API.
      # @param [String, nil] filename the file to load the words from.
      # @return [Root] the trie just created.
      # @yield [Root] the trie just created.
      def create(filename = nil)
        Root.new do |root|
          words_from(filename) { |word| root << word } if filename
          yield root if block_given?
        end
      end

      private
      def words_from(filename)
        File.open(filename) { |file| file.each_line { |line| yield line.chomp } }
      end
    end
  end
end
