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
      # @param [String, nil] filename the file to load the words from (defaults to nil).
      def create(filename = nil)
        Root.new filename
      end
    end
  end
end
