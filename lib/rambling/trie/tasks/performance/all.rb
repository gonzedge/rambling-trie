namespace :performance do
  desc 'Generate all profiling and performance reports'
  task all: [
    'benchmark:all',
    'profile:call_tree:all',
    'profile:memory:all',
    'flamegraph:all',
  ]

  namespace :all do
    desc 'Generate and store all profiling and performance reports'
    task save: [
      'benchmark:all:save',
      'profile:call_tree:all',
      'profile:memory:all',
      'flamegraph:all',
    ]
  end
end
