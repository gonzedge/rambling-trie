%w{
  compressed raw
}.each do |task|
  require_relative File.join('scan', task)
end
