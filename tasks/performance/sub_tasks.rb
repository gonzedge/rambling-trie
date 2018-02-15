%w{
  sub_task initialization compression creation lookups serialization
}.each do |task|
  require_relative File.join('sub_tasks', task)
end
