[
  'rambling',
  'rambling-trie/invalid_operation',
  'rambling-trie/children_hash_deferer',
  'rambling-trie/compressor',
  'rambling-trie/branches',
  'rambling-trie/node',
  'rambling-trie/root',
  'rambling-trie/version'
].each do |file|
  require File.join File.dirname(__FILE__), file
end
