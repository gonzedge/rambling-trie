# frozen_string_literal: true

path = File.join 'rambling', 'trie', 'readers'
%w(reader plain_text).each { |file| require File.join(path, file) }

module Rambling
  module Trie
    # Namespace for all readers.
    module Readers
    end
  end
end
