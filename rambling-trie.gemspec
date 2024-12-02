# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'rambling/trie/version'

Gem::Specification.new do |gem|
  gem.authors = ['Edgar Gonzalez', 'Lilibeth De La Cruz']
  gem.email = %w(edggonzalezg@gmail.com lilibethdlc@gmail.com)

  gem.description = <<~DESCRIPTION.gsub(%r{\s+}, ' ')
    The Rambling Trie is a Ruby implementation of the trie data structure, which
    includes compression abilities and is designed to be very fast to traverse.
  DESCRIPTION

  gem.summary = 'A Ruby implementation of the trie data structure.'
  gem.homepage = 'https://github.com/gonzedge/rambling-trie'
  gem.metadata = {
    'changelog_uri' => 'https://github.com/gonzedge/rambling-trie/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/rambling-trie',
    'rubygems_mfa_required' => 'true',
  }

  executables = `git ls-files -- bin/*`.split "\n"
  files = `git ls-files -- {lib,sig,*file,*.gemspec,LICENSE*,README*}`.split "\n"

  gem.executables = executables.map { |f| File.basename f }
  gem.files = files
  gem.require_paths = %w(lib)

  gem.name = 'rambling-trie'
  gem.license = 'MIT'
  gem.version = Rambling::Trie::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 3.1', '< 4'
end
