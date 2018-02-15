%w{
  compressed raw
}.each do |task|
  require_relative File.join('words_within', task)
end
