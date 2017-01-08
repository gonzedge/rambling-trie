require 'forwardable'
%w{plain_text}.each do |file|
  require File.join('rambling', 'trie', 'readers', file)
end
