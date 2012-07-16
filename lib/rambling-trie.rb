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
      def create(*params)
        Root.new *params
      end
    end
  end
end
