%w{file marshal yaml}.each do |file|
  require File.join('rambling', 'trie', 'serializers', file)
end

module Rambling
  module Trie
    # Namespace for all serializers.
    module Serializers
    end
  end
end
