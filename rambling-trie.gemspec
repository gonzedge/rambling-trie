Gem::Specification.new do |s|
  files = Dir[File.join(File.dirname(__FILE__), 'lib', '*')]

  s.name = 'rambling-trie'
  s.version = '0.0.2'
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Rambling Trie'
  s.description = 'A custom trie implementation'
  s.authors = ['Edgar Gonzalez', 'Lilibeth De La Cruz']
  s.email = 'edgar@ramblinglabs.com'
  s.files = files
  s.homepage = 'http://rubygems.org/gems/rambling-trie'
end
