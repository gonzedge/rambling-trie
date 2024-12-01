# frozen_string_literal: true

path = File.join 'rambling', 'trie', 'serializers'
%w(serializer file marshal yaml zip).each { |file| require File.join(path, file) }

module Rambling
  module Trie
    # Namespace for all serializers.
    module Serializers
    end
  end
end
