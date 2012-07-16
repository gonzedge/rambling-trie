[
  'invalid_operation',
  'children_hash_deferer',
  'compressor',
  'branches',
  'node',
  'root',
  'version'
].each { |file| require File.join('rambling-trie', file) }

module Rambling
  module Trie
    class << self
      def create(*params)
        Root.new *params
      end
    end
  end
end
