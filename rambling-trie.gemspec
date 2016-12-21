# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'rambling/trie/version'

Gem::Specification.new do |gem|
  gem.authors = ['Edgar Gonzalez', 'Lilibeth De La Cruz']
  gem.email = ['edggonzalezg@gmail.com', 'lilibethdlc@gmail.com']
  gem.description = 'The Rambling Trie is a custom implementation of the Trie data structure with Ruby, which includes compression abilities and is designed to be very fast to traverse.'
  gem.summary = 'A custom implementation of the trie data structure.'
  gem.homepage = 'http://github.com/gonzedge/rambling-trie'
  gem.date = Time.now.strftime '%Y-%m-%d'

  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename f }
  gem.files = `git ls-files`.split "\n"
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split "\n"
  gem.require_paths = ['lib']

  gem.name = 'rambling-trie'
  gem.license = 'MIT'
  gem.version = Rambling::Trie::VERSION
  gem.platform = Gem::Platform::RUBY

  gem.add_development_dependency 'rspec', '~> 3.5'
  gem.add_development_dependency 'rake', '~> 12.0'
  gem.add_development_dependency 'ruby-prof', '~> 0.16.2'
  gem.add_development_dependency 'memory_profiler', '~> 0.9.7'
  gem.add_development_dependency 'yard', '~> 0.9.5'
  gem.add_development_dependency 'redcarpet', '~> 3.3.4'
end
