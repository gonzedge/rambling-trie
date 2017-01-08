require 'forwardable'
%w{marshal yaml}.each do |file|
  require File.join('rambling', 'trie', 'serializers', file)
end
