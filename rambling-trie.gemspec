Gem::Specification.new do |s|
  files = Dir[File.join(File.dirname(__FILE__), 'lib', '*')]

  s.name = 'rambling-trie'
  s.version = '0.2.0'
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Rambling Trie'
  s.description = 'A custom implementation of the trie data structure'
  s.authors = ['Rambling Labs']
  s.email = 'development@ramblinglabs.com'
  s.files = files
  s.homepage = 'http://rubygems.org/gems/rambling-trie'
end
