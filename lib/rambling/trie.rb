require 'forwardable'
%w{
  branches compression enumerable inspector invalid_operation node
  missing_node plain_text_reader root compressor raw/node container
  version
}.each do |file|
  require File.join('rambling', 'trie', file)
end

# General namespace for all Rambling gems.
module Rambling
  # Entry point for rambling-trie API.
  module Trie
    class << self
      # Creates a new Trie. Entry point for the Rambling::Trie API.
      # @param [String, nil] filepath the file to load the words from.
      # @return [Container] the trie just created.
      # @yield [Container] the trie just created.
      def create filepath = nil, reader = nil
        reader ||= default_reader

        Rambling::Trie::Container.new do |container|
          if filepath
            reader.each_word filepath do |word|
              container << word
            end
          end

          yield container if block_given?
        end
      end

      private

      def default_reader
        Rambling::Trie::PlainTextReader.new
      end
    end
  end
end
