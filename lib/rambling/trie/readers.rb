%w{plain_text}.each do |file|
  require File.join('rambling', 'trie', 'readers', file)
end

module Rambling
  module Trie
    # Namespace for all readers.
    module Readers
    end
  end
end
