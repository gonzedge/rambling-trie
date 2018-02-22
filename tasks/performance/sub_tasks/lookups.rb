# frozen_string_literal: true

%w(partial_word scan word words_within).each do |task|
  require_relative File.join('lookups', task)
end
