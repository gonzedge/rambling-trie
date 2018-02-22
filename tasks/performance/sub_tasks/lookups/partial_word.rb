# frozen_string_literal: true

%w(compressed raw).each do |task|
  require_relative File.join('partial_word', task)
end
