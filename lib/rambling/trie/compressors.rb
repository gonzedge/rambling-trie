# frozen_string_literal: true

%w(compressor with_merging_strategy with_garbage_collection).each do |file|
  require File.join('rambling', 'trie', 'compressors', file)
end

module Rambling
  module Trie
    # Namespace for all compressors.
    module Compressors
    end
  end
end
