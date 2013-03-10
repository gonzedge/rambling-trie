require 'forwardable'
%w{
  branches compressor enumerable
  inspector invalid_operation node
  plain_text_reader root version
}.map { |file| File.join 'rambling', 'trie', file }.each &method(:require)

# General namespace for all Rambling gems.
module Rambling
  # Entry point for rambling-trie API.
  module Trie
    class << self
      # Creates a new Trie. Entry point for the Rambling::Trie API.
      # @param [String, nil] filepath the file to load the words from.
      # @return [Root] the trie just created.
      # @yield [Root] the trie just created.
      def create(filepath = nil, reader = PlainTextReader.new)
        Root.new do |root|
          reader.each_word(filepath) { |word| root << word } if filepath
          yield root if block_given?
        end
      end
    end
  end
end
