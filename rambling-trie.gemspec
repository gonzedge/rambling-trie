# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'rambling/trie/version'

Gem::Specification.new do |gem|
  gem.authors = ['Edgar Gonzalez', 'Lilibeth De La Cruz']
  gem.email = ['edggonzalezg@gmail.com', 'lilibethdlc@gmail.com']

  gem.description = <<~DESCRIPTION.gsub(%r{\s+}, ' ')
    The Rambling Trie is a Ruby implementation of the trie data structure, which
    includes compression abilities and is designed to be very fast to traverse.
  DESCRIPTION

  gem.summary = 'A Ruby implementation of the trie data structure.'
  gem.homepage = 'http://github.com/gonzedge/rambling-trie'
  gem.date = Time.now.strftime '%Y-%m-%d'
  gem.metadata = {
    'changelog_uri' => 'https://github.com/gonzedge/rambling-trie/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/rambling-trie',
  }

  executables = `git ls-files -- bin/*`.split "\n"
  files = `git ls-files -- {lib,*file,*.gemspec,LICENSE*,README*}`.split "\n"
  test_files = `git ls-files -- {test,spec,features}/*`.split "\n"

  gem.executables = executables.map { |f| File.basename f }
  gem.files = files
  gem.test_files = test_files
  gem.require_paths = %w(lib)

  gem.name = 'rambling-trie'
  gem.license = 'MIT'
  gem.version = Rambling::Trie::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 2.7', '< 4'

  gem.add_development_dependency 'rake', '~> 13.0'
  gem.add_development_dependency 'rspec', '~> 3.12'
  gem.add_development_dependency 'yard', '~> 0.9.28'
end
