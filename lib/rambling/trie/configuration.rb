%w{properties provider_collection}.each do |file|
  require File.join('rambling', 'trie', 'configuration', file)
end

module Rambling
  module Trie
    # Namespace for configuration classes.
    module Configuration
    end
  end
end
