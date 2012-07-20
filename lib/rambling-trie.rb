[
  'invalid_operation',
  'children_hash_deferer',
  'compressor',
  'branches',
  'node',
  'root',
  'version'
].map { |file| File.join('rambling-trie', file) }.each &method(:require)

module Rambling
  module Trie
    class << self
      # Creates a new Trie. Entry point for the Rambling::Trie API.
      # @param [String, nil] filename the file to load the words from (defaults to nil).
      def create(*params)
        Root.new *params
      end

      # @deprecated Please use {#create} instead
      def new(*params)
        warn '[DEPRECATION] `new` is deprecated. Please use `create` instead.'
        create *params
      end
    end
  end
end
