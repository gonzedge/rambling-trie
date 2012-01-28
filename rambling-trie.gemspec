Gem::Specification.new do |s|
  version = `git tag -l | head -1`
  version = '0.0.0' if version.empty?

  s.name = 'rambling-trie'
  s.version = version
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Rambling Trie'
  s.description = 'A custom trie implementation'
  s.authors = ['Edgar Gonzalez', 'Lilibeth De La Cruz']
  s.email = 'edggonzalezg@gmail.com'
  s.files = ['lib/rambling-trie.rb', 'lib/trie.rb', 'lib/trie_node.rb']
  s.homepage = 'http://rubygems.org/gems/rambling-trie'
end
