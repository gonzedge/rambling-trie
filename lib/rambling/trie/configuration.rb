# frozen_string_literal: true

path = File.join 'rambling', 'trie', 'configuration'
%w(properties provider_collection).each { |file| require File.join(path, file) }

module Rambling
  module Trie
    # Namespace for configuration classes.
    module Configuration
    end
  end
end
