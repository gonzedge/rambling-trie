# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rambling-trie/version'

Gem::Specification.new do |s|
  files = Dir[File.join(File.dirname(__FILE__), 'lib', '**', '**')].reject { |x| File.directory?(x) } + %w(LICENSE README.markdown)

  s.name = 'rambling-trie'
  s.version = Rambling::Trie::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Rambling Labs']
  s.email = 'development@ramblinglabs.com'
  s.homepage = 'http://github.com/ramblinglabs/rambling-trie'
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'A custom implementation of the trie data structure.'
  s.description = 'The Rambling Trie is a custom implementation of the Trie data structure with Ruby, which includes compression abilities and is designed to be very fast to traverse.'

  s.add_development_dependency 'rspec', '>=2.0.0'
  s.add_development_dependency 'rake', '>=0.9.2'
  s.add_development_dependency 'ruby-prof', '>=0.10.8'
  s.add_development_dependency 'yard', '>=0.7.5'
  s.add_development_dependency 'redcarpet', '>=2.1.0'

  s.files = files
  s.require_path = 'lib'
end
