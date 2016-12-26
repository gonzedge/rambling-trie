namespace :performance do
  desc 'Generate profiling and performance reports'
  task all: [
    'benchmark:all',
    'profile:call_tree:all',
    'profile:memory:all',
  ]
end
