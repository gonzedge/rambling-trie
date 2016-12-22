namespace :performance do
  desc 'Generate profiling and performance reports'
  task all: ['profile:call_tree', :report]
end
