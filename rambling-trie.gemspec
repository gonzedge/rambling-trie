Gem::Specification.new do |s|
  files = Dir[File.join(File.dirname(__FILE__), 'lib', '*')] + %w(LICENSE README.markdown)

  s.name = 'rambling-trie'
  s.version = '0.3.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Rambling Labs']
  s.email = 'development@ramblinglabs.com'
  s.homepage = 'http://github.com/ramblinglabs/rambling-trie'
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'A custom implementation of the trie data structure.'
  s.description = 'The Rambling Trie is a custom implementation of the Trie data structure with Ruby, which includes compression abilities and is designed to be very fast to traverse.'

  s.add_development_dependency 'rspec', '>=2.0.0'

  s.files = files
  s.require_path = 'lib'
end
