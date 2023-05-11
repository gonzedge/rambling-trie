# frozen_string_literal: true

%w(serializer file marshal yaml zip).each do |file|
  require File.join('rambling', 'trie', 'serializers', file)
end

module Rambling
  module Trie
    # Namespace for all serializers.
    module Serializers
    end
  end
end
