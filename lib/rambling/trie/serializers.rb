require 'forwardable'
%w{file marshal yaml}.each do |file|
  require File.join('rambling', 'trie', 'serializers', file)
end
