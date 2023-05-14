# Rambling Trie

[![Gem Version][badge_fury_badge]][badge_fury_link]
[![Downloads][downloads_badge]][downloads_link]
[![License][license_badge]][license_link]

[![Build Status][github_action_build_badge]][github_action_build_link]
[![Coverage Status][coveralls_badge]][coveralls_link]
[![Documentation Status][inch_ci_badge]][rubydoc]
[![CodeQL Status][github_action_codeql_badge]][github_action_codeql_link]

[![Code Climate Grade][code_climate_grade_badge]][code_climate_link]
[![Code Climate Issue Count][code_climate_issues_badge]][code_climate_link]

The Rambling Trie is a Ruby implementation of the [trie data structure][trie_wiki], which includes compression abilities and is designed to be very fast to traverse.

## Installing the Rambling Trie

### Requirements

You will need:

* Ruby 2.7.0 or up
* RubyGems

See [RVM][rvm], [rbenv][rbenv] or [chruby][chruby] for more information on how to manage Ruby versions.

### Installation

You can either install it manually with:

``` bash
gem install rambling-trie
```

Or, include it in your `Gemfile` and bundle it:

``` ruby
gem 'rambling-trie'
```

## Using the Rambling Trie

### Creation

To create a new trie, initialize it like this:

``` ruby
trie = Rambling::Trie.create
```

You can also provide a block and the created trie instance will be yielded for you to perform any operation on it:

``` ruby
Rambling::Trie.create do |trie|
  trie << 'word'
end
```

Additionally, you can provide the path to a file that contains all the words to be added to the trie, and it will read the file and create the complete structure for you, like this:

``` ruby
trie = Rambling::Trie.create '/path/to/file'
```

By default, a plain text file with the following format will be expected:

``` text
some
words
to
populate
the
trie
```

If you want to use a custom file format, you will need to provide a custom file reader that defines an `#each_word` method that yields each word contained in the file. Look at the [`PlainText` reader][rambling_trie_plain_text_reader] class for an example, and at the [Configuration section][rambling_trie_configuration] to see how to add your own custom file readers.

### Operations

To add new words to the trie, use `#add` or its alias `#<<`:

``` ruby
trie.add 'word'
trie << 'word'
```

Or if you have multiple words to add, you can use `#concat`:

``` ruby
trie.concat %w(a collection of words)
```

And to find out if a word already exists in the trie, use `#word?` or its alias `#include?`:

``` ruby
trie.word? 'word'
trie.include? 'word'
```

If you wish to find if part of a word exists in the trie instance, you should call `#partial_word?` or its alias `#match?`:

``` ruby
trie.partial_word? 'partial_word'
trie.match? 'partial_word'
```

To get all the words that start with a particular string, you can use `#scan` or its alias `#words`:

``` ruby
trie.scan 'hi' # => ['hi', 'high', 'highlight', ...]
trie.words 'hi' # => ['hi', 'high', 'highlight', ...]
```

To get all the words within a given string, you can use `#words_within`:

``` ruby
trie.words_within 'ifdxawesome45someword3' # => ['if', 'aw', 'awe', ...]
trie.words_within 'tktktktk' # => []
```

Or, if you're just interested in knowing whether a given string contains any valid words or not, you can use `#words_within?`:

``` ruby
trie.words_within? 'ifdxawesome45someword3' # => true
trie.words_within? 'tktktktk' # => false
```

### Compression

By default, the Rambling Trie works as a standard trie. Starting from version 0.1.0, you can obtain a compressed trie from the standard one, by using the compression feature. Just call the `#compress!` method on the trie instance:

``` ruby
trie.compress!
```

This will reduce the size of the trie by using redundant node elimination (redundant nodes are the only-child non-terminal nodes).

> _**Note**: The `#compress!` method acts over the trie instance it belongs to
> and replaces the root `Node`. Also, adding words after compression (with `#add` or
> `#<<`) is not supported._

If you want, you can also create a new compressed trie and leave the existing one intact. Just use `#compress` instead:

``` ruby
compressed_trie = trie.compress
```

You can find out if a trie instance is compressed by calling the `#compressed?` method. From the `#compress` example:

``` ruby
trie.compressed? # => false
compressed_trie.compressed? # => true
```

### Enumeration

Starting from version 0.4.2, you can use any `Enumerable` method over a trie instance, and it will iterate over each word contained in the trie. You can now do things like:

``` ruby
trie.each { |word| puts word }
trie.any? { |word| word.include? 'x' }
trie.all? { |word| word.include? 'x' }
# etc.
```

### Serialization

Starting from version 1.0.0, you can store a full trie instance on disk and retrieve/use it later on. Loading a trie from disk takes less time, less cpu and less memory than loading every word into the trie every time. This is particularly useful for production applications, when you have word lists that you know are going to be static, or that change with little frequency.

To store a trie on disk, you can use `.dump` like this:

``` ruby
Rambling::Trie.dump trie, '/path/to/file'
```

Then, when you need to use a trie next time, you don't have to create a new one with all the necessary words. Rather, you can retrieve a previously stored one with `.load` like this:

``` ruby
trie = Rambling::Trie.load '/path/to/file'
```

#### Supported formats

Currently, these formats are supported to store tries on disk:

* Ruby's [binary (Marshal)][marshal] format
* [YAML][yaml]

> When dumping into or loading from disk, the format is determined
> automatically based on the file extension, so `.yml` or `.yaml` files will be
> handled through `YAML` and `.marshal` files through `Marshal`.

Optionally, you can use a `.zip` version of the supported formats. In order to do so, you'll have to install the [`rubyzip`][rubyzip] gem:

``` bash
gem install rubyzip
```

Or, include it in your `Gemfile` and bundle it:

``` ruby
gem 'rubyzip'
```

Then, you can load contents form a `.zip` file like this:

``` ruby
require 'zip'
trie = Rambling::Trie.load '/path/to/file.zip'
```

> For `.zip` files, the format is also determined automatically based on the
> file extension, so `.yml.zip` or `.yaml.zip` files will be handled through
> `YAML` after decompression and `.marshal.zip` files through `Marshal`.

### Configuration

Starting from version 1.0.0, you can change the configuration values used by Rambling Trie. You can now supply:

* A `Compressor` object
* A root `Node` builder
* More `Readers` (implement `#each_word`)
* Change the default `reader`
* More `Serializers` (implement `#dump` and `#load`)
* Change the default `serializer`

You can configure those values by using `.config` like this:

```ruby
require 'rambling-trie'

Rambling::Trie.config do |config|
  config.compressor = MyCompressor.new
  config.root_builder = lambda { MyNode.new }

  config.readers.add :html, MyHtmlReader.new
  config.readers.default = config.readers[:html]

  config.serializers.add :json, MyJsonSerializer.new
  config.serializers.default = config.serializers[:yml]
end

# Create a trie or load one from disk and do things with it...
```

### Further Documentation

You can find further API documentation on the autogenerated [rambling-trie gem RubyDoc.info page][rubydoc] or if you want edge documentation, you can go the [GitHub project RubyDoc.info page][rubydoc_github].

## Compatible Ruby and Rails versions

The Rambling Trie has been tested with the following Ruby versions:

* 3.2.x
* 3.1.x
* 3.0.x
* 2.7.x

**No longer supported**:

* 2.6.x (EOL'ed)
* 2.5.x (EOL'ed)
* 2.4.x (EOL'ed)
* 2.3.x (EOL'ed)
* 2.2.x (EOL'ed)
* 2.1.x (EOL'ed)
* 2.0.x (EOL'ed)
* 1.9.x (EOL'ed)
* 1.8.x (EOL'ed)

## Contributing to Rambling Trie

Take a look at the [contributing guide][rambling_trie_contributing_guide] to get started, or fire a question to [@gonzedge][github_user_gonzedge].

## License and copyright

Copyright (c) 2012-2023 Edgar González

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[badge_fury_badge]: https://badge.fury.io/rb/rambling-trie.svg?version=2.3.1
[badge_fury_link]: https://badge.fury.io/rb/rambling-trie
[chruby]: https://github.com/postmodern/chruby
[code_climate_grade_badge]: https://codeclimate.com/github/gonzedge/rambling-trie/badges/gpa.svg
[code_climate_issues_badge]: https://codeclimate.com/github/gonzedge/rambling-trie/badges/issue_count.svg
[code_climate_link]: https://codeclimate.com/github/gonzedge/rambling-trie
[coveralls_badge]: https://img.shields.io/coveralls/gonzedge/rambling-trie.svg
[coveralls_link]: https://coveralls.io/r/gonzedge/rambling-trie
[downloads_badge]: https://img.shields.io/gem/dt/rambling-trie.svg
[downloads_link]: https://rubygems.org/gems/rambling-trie
[gemnasium_badge]: https://gemnasium.com/gonzedge/rambling-trie.svg
[gemnasium_link]: https://gemnasium.com/gonzedge/rambling-trie
[github_action_build_badge]: https://github.com/gonzedge/rambling-trie/actions/workflows/ruby.yml/badge.svg
[github_action_build_link]: https://github.com/gonzedge/rambling-trie/actions/workflows/ruby.yml
[github_action_codeql_badge]: https://github.com/gonzedge/rambling-trie/actions/workflows/codeql.yml/badge.svg
[github_action_codeql_link]: https://github.com/gonzedge/rambling-trie/actions/workflows/codeql.yml
[github_user_gonzedge]: https://github.com/gonzedge
[inch_ci_badge]: https://inch-ci.org/github/gonzedge/rambling-trie.svg?branch=master
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/mit-license.php
[marshal]: https://ruby-doc.org/core-2.7.0/Marshal.html
[rambling_trie_configuration]: https://github.com/gonzedge/rambling-trie#configuration
[rambling_trie_contributing_guide]: https://github.com/gonzedge/rambling-trie/blob/master/CONTRIBUTING.md
[rambling_trie_plain_text_reader]: https://github.com/gonzedge/rambling-trie/blob/master/lib/rambling/trie/readers/plain_text.rb
[rbenv]: https://github.com/sstephenson/rbenv
[rubydoc]: http://rubydoc.info/gems/rambling-trie
[rubydoc_github]: http://rubydoc.info/github/gonzedge/rambling-trie
[rubyzip]: https://github.com/rubyzip/rubyzip
[rvm]: https://rvm.io
[trie_wiki]: https://en.wikipedia.org/wiki/Trie
[yaml]: https://ruby-doc.org/stdlib-2.7.0/libdoc/yaml/rdoc/YAML.html
