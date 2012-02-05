# Rambling Trie

The Rambling Trie is a custom implementation of the Trie data structure with Ruby.

## Installing the Rambling Trie

### Requirements

You will need:

* Ruby 1.9.2 or up
* RubyGems

See [RVM](http://beginrescueend.com) or [rbenv](https://github.com/sstephenson/rbenv) for more information on how to manage Ruby versions.

### Installation

You can either install it manually with:

`gem install rambling-trie`

Or, include it in your `Gemfile` and bundle it:

`gem 'rambling-trie'`

## How to use the Rambling Trie

To create the trie, initialize it like this:

<pre><code>trie = Rambling::Trie.new
</code></pre>

You can also provide a file which contains all the words to be added to the trie, and it will read the file and create the structure for you, like this:

<pre><code>trie = Rambling::Trie.new('/path/to/file')
</code></pre>

To add new words to the trie, use `add_branch_from`:

<pre><code>trie.add_branch_from('word')
</code></pre>

And to find out if a word already exists in the trie, use `has_branch_tree?`:

<pre><code>trie.has_branch_tree?('word')
</code></pre>

## Compatible Ruby and Rails versions

The Rambling Trie has been tested with the following Ruby versions:

* 1.9.2
* 1.9.3

And the following Rails versions:

* 3.1.x
* 3.2.x

It's possible that Ruby 1.8.7 and Rails 3.0.x are supported, but there is no guarantee.

## Contributing to Rambling Trie

If you want to contribute to this project, you will need RSpec to run the tests.
Also, be sure to add tests for any feature you may develop or bug you may fix.

## License and copyright

Copyright (c) 2012 Rambling Labs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

