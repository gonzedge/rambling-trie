%w{
  reporter benchmark call_tree_profile flamegraph memory_profile
}.each do |name|
  require_relative File.join('reporters', name)
end
