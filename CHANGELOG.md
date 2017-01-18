# Changelog

## 1.0.0 (unreleased) [compare][compare-v0.9.3-and-master]

### Breaking Changes

- Rename `PlainTextReader` to `Readers::PlainText` by [@gonzedge][github-user-gonzedge]
- Rename `Compression` to `Compressable` by [@gonzedge][github-user-gonzedge]
- Rename `Inspect` to `Inspectable` by [@gonzedge][github-user-gonzedge]

### Enhancements

#### Major

- Add `Serializers` to dump trie into/load trie from disk
  [#10][github-issue-10] by [@gonzedge][github-user-gonzedge]

    ``` ruby
    # Save `your_trie` into a file
    Rambling::Trie.dump your_trie, 'a filename'

    # Load a trie from a file into memory
    trie = Rambling::Trie.load 'a filename'
    ```

- Add ability to configure `rambling-trie` [#11][github-issue-11]
  by [@gonzedge][github-user-gonzedge]

    ``` ruby
    Rambling::Trie.config do |config|
      config.compressor = MyCompressor.new
      config.root_builder = lambda { MyNode.new }

      config.readers.add :html, MyHtmlReader.new
      config.readers.default = config.readers[:html]

      config.serializers.add :json, MyJsonSerializer.new
      config.serializers.default = config.serializers[:yml]
    end
    ```

- Add `#==` to compare nodes by [@gonzedge][github-user-gonzedge]

    Contained in `Rambling::Trie::Comparable` module. Two nodes are equal to
    each other if they have the same letter, they are both either terminal or
    non-terminal and their children tree is the same

#### Minor

- Extract modules for peripheral node functionality by [@gonzedge][github-user-gonzedge]
    - Move `#to_s` to `Stringifyable` module
    - Move `#as_word` to `Stringifyable` module by
    - Move `#==` to `Comparable` module
    - Rename `Compression` to `Compressable`
    - Rename `Inspector` to `Inspectable`
- Add `#terminal?` value to inspect output by [@gonzedge][github-user-gonzedge]
- Freeze `Rambling::Trie::VERSION` by [@gonzedge][github-user-gonzedge]
- Refactor performance instrumentation tasks by
  [@gonzedge][github-user-gonzedge]
    - Add `Performance` module
    - Add `Performance::Reporter` & `Performance::Directory` classes
    - Move task execution into individual classes
    - Unify all tasks into single entry point `rake performance[type,method]`
- Change benchmark report format by [@gonzedge][github-user-gonzedge]
- Correct supported versions by [@gonzedge][github-user-gonzedge]
- Only create new `Reader` instance when filepath is given on initialization by
  [@gonzedge][github-user-gonzedge]
- Update license year by [@gonzedge][github-user-gonzedge]

## 0.9.3 [compare][compare-v0.9.2-and-v0.9.3]

### Enhancements

#### Major

- Add Ruby 2.4 to supported versions by [@gonzedge][github-user-gonzedge]
- Drastically reduce size of gem by [@gonzedge][github-user-gonzedge]

    By excluding unnecessary `assets/` and `reports/` when building the gem.
    **Size reduction**: from ~472KB to ~21KB.

- Make root node accessible via container by [@gonzedge][github-user-gonzedge]

    So that anyone using rambling-trie can develop their custom algorithms

- Expose root node's `#to_a` method through `Container` by
  [@gonzedge][github-user-gonzedge]
- Add own `Forwardable#delegate` because of [Ruby 2.4 performance
  degradation][ruby-bug-13111] by [@gonzedge][github-user-gonzedge]

    Was able to take Creation and Compression benchmarks (~8.8s and ~1.5s
    respectively) back down to the Ruby 2.3.3 levels by adding own definition of
    `Forwardable#delegate`.

#### Minor

- Ensure unicode words are supported by [@gonzedge][github-user-gonzedge]
- Add flamegraph reports to performance instrumentation tasks by
  [@gonzedge][github-user-gonzedge]
- Move benchmark/profiling dependencies from gemspec to Gemfile by
  [@gonzedge][github-user-gonzedge]
- Add missing docs by [@gonzedge][github-user-gonzedge]
- Improvements on TravisCI setup by [@gonzedge][github-user-gonzedge]
- Add codeclimate test coverage integration by
  [@gonzedge][github-user-gonzedge]
- Move rspec config from .rspec to spec_helper by
  [@gonzedge][github-user-gonzedge]

## 0.9.2 [compare][compare-v0.9.1-and-v0.9.2]

### Enhancements

#### Major

- Fix "undefined method `to_sym`" on compressed trie's `#partial_word?` and
  `#scan` by [@gonzedge][github-user-gonzedge]
- Expose all usable `Node` methods in `Container` through delegation by
  [@gonzedge][github-user-gonzedge]
    - Expose `#as_word`
    - Expose `#children`
    - Expose `#children_tree`
    - Expose `#has_key?`
    - Expose `#parent`
    - Expose `#size`
    - Expose `#to_s`

#### Minor

- Unify `#scan` implementation between `Raw` and `Compressed` node by
  [@gonzedge][github-user-gonzedge]

## 0.9.1 [compare][compare-v0.9.0-and-v0.9.1]

### Enhancements

#### Major

- Performance improvements for all trie operations by
  [@gonzedge][github-user-gonzedge]
- Reduce memory footprint without affecting performance for compressed node
  operations by [@gonzedge][github-user-gonzedge]

    Including `#word?`, `#partial_word?` and `#closest_node`. See these commits
    for more info:

    - [aa8c0262f888e88df6a2f1e1351d8f14b21e43c4][github-commit-reduced-memory-footprint]
    - [218fac218a77e70ba04a3672ff5abfddf6544f57][github-commit-current-key-less-memory]

#### Minor

- Make trie integration test a bit faster by [@gonzedge][github-user-gonzedge]
- Remove unnecessary `#to_a` calls from `Container` by
  [@gonzedge][github-user-gonzedge]
- Extract `#recursive_get` to unify `#partial_word?` and `#scan`
  implementations by [@gonzedge][github-user-gonzedge]
- Better `#word?` implementation for compressed node by
  [@gonzedge][github-user-gonzedge]
- Rename `new_letter` => `letter` by [@gonzedge][github-user-gonzedge]
- Further performance instrumentation improvements by
  [@gonzedge][github-user-gonzedge]
- Split out benchmark reports per version by [@gonzedge][github-user-gonzedge]

## 0.9.0 [compare][compare-v0.8.1-and-v0.9.0]

### Breaking Changes

- `Rambling::Trie.create` now returns a `Container` instead of a `Root` by
  [@gonzedge][github-user-gonzedge]

    `Container` exposes these API entry points:

    - `#partial_word?` and its alias `#match?`
    - `#word?` and its alias `#include?`
    - `#add` and its alias `#<<`
    - yield the constructed `Container` on `#initialize`

    `Rambling::Trie::Node` and its subclasses no longer expose:

    - `#match?`
    - `#include?`
    - `#<<`
    - yield on `#initialize`

- Remove `Branches` module, all of its behavior is now contained in `RawNode`
  and `CompressedNode` by [@gonzedge][github-user-gonzedge]
- Rename `Compressor` module to `Compression` (`Compressor` is now the class
  that transforms between a `RawNode` and a `CompressedNode`) by
  [@gonzedge][github-user-gonzedge]

### Enhancements

#### Major

- Separate uncompressed trie vs compressed trie logic into separate objects by
  [@gonzedge][github-user-gonzedge]
    - Create separate `RawNode` and `CompressedNode` classes
    - Add `Compressor` for `#compress!` implementation that maps from a
      `RawNode` to a `CompressedNode`
    -
- Add `#terminal!` to `Node` to force node to be terminal by
  [@gonzedge][github-user-gonzedge]
- Move `#root?` into `Node` by [@gonzedge][github-user-gonzedge]
- Improve memory footprint of compressed trie (`CompressedNode`) by
  [@gonzedge][github-user-gonzedge]
- Small memory improvements to `RawNode` by [@gonzedge][github-user-gonzedge]
- Improve `Rambling::Trie::Enumerable` performance, hence `#scan` performance
  by [@gonzedge][github-user-gonzedge]
- Improve performance for `#scan` by [@gonzedge][github-user-gonzedge]
- Additional performance improvements for raw and compressed nodes operations
  by [@gonzedge][github-user-gonzedge]
- Improve trie creation performance by [@gonzedge][github-user-gonzedge]
- Improve performance of trie initialization from file by
  [@gonzedge][github-user-gonzedge]

#### Minor

- Delegate `#inspect` to `#root` node by [@gonzedge][github-user-gonzedge]
- Rename `first_letter` to `letter` in `RawNode` by
  [@gonzedge][github-user-gonzedge]
- Expand performance instrumentation by [@gonzedge][github-user-gonzedge]

    Include memory profiles, call tree profiles and benchmark measurements for
    `#scan` method

## 0.8.1 [compare][compare-v0.8.0-and-v0.8.1]

### Enhancements

#### Major

- Fix `NoMethodError` missing branch from compressed root [#8][github-issue-08]
  by [@gonzedge][github-user-gonzedge]
- Add Ruby 2.2.5, 2.2.6, 2.3.1, 2.3.2 and 2.3.3 to supported versions by
  [@gonzedge][github-user-gonzedge]

## 0.8.0 [compare][compare-v0.7.0-and-v0.8.0]

### Breaking Changes

- Drop support for Ruby 1.9.x and 2.0.x by [@gonzedge][github-user-gonzedge]

### Enhancements

#### Major

- Add `#scan` method and its alias `#words` to find all words that match a
  given partial word [#7][github-issue-07] by [@gonzedge][github-user-gonzedge]
    - Return matching `Node`
    - Use [Null Object pattern][design-patterns-null-object] to return empty
      array with `Rambling::Trie::MissingNode`
- Add Ruby 2.1.6, 2.1.7, 2.1.8, 2.2.1, 2.2.2, 2.2.3, 2.2.4, and 2.3.0 to
  supported versions by [@gonzedge][github-user-gonzedge]

#### Minor

- Update license date by [@gonzedge][github-user-gonzedge]

## 0.7.0 [compare][compare-v0.6.1-and-v0.7.0]

### Breaking Changes

- Remove deprecated `#branch?` method by [@gonzedge][github-user-gonzedge]
- Drop support for Ruby 1.9.2 by [@gonzedge][github-user-gonzedge]
- Remove Rails version specification (not relevant) by
  [@gonzedge][github-user-gonzedge]

### Enhancements

#### Major

- Add Ruby 2.1.0, 2.1.1, 2.1.2, 2.1.3, 2.1.4, 2.1.5 to supported versions by
  [@gonzedge][github-user-gonzedge]
- Upgrade to RSpec 3 [@gonzedge][github-user-gonzedge]
    - Update gem dependencies and be more restrictive about gem dependecy
      versions
    - Update other dev dependencies
    - Use RSpec's new syntax for message expectations
- Add LICENSE to gemspec by [@gonzedge][github-user-gonzedge]

#### Minor

- Update license by [@gonzedge][github-user-gonzedge]
- Explicitly define `#<<` alias for `#add` by [@gonzedge][github-user-gonzedge]

    This avoids having to call `.alias_method` again for
    `#add` method overloads.

## 0.6.1 [compare][compare-v0.6.0-and-v0.6.1]

### Enhancements

#### Major

- Performance improvements on uncompressed `#word?` and `#partial_word?` by
  [@gonzedge][github-user-gonzedge]

## 0.6.0 [compare][compare-v0.5.2-and-v0.6.0]

### Breaking Changes

- Change return value of `#children` by [@gonzedge][github-user-gonzedge]

     Returns the array of child nodes instead of the `Hash` representing the tree
     of children

- Rename `#branch?` method to `#partial_word?` by [@gonzedge][github-user-gonzedge]
- Rename old `#children` method to `#children_tree` by [@gonzedge][github-user-gonzedge]

### Enhancements

#### Major

- Add `#root?` method by [@gonzedge][github-user-gonzedge]
- Add Ruby 2.0.0 to supported versions by [@gonzedge][github-user-gonzedge]

#### Minor

- Remove perftools.rb dependency by [@gonzedge][github-user-gonzedge]
- Use `Forwardable` instead of own delegator by [@gonzedge][github-user-gonzedge]
- Specify 'MIT License' in the license file by [@gonzedge][github-user-gonzedge]
- Update license year by [@gonzedge][github-user-gonzedge]

## 0.5.2 [compare][compare-v0.5.1-and-v0.5.2]

### Enhancements

#### Major

- Add `#to_s` method for node by [@gonzedge][github-user-gonzedge]

#### Minor

- Safer `#letter=` implementation by [@gonzedge][github-user-gonzedge]
- Refactor `#as_word` to use `#to_s` by [@gonzedge][github-user-gonzedge]
- Change spec format and remove rails matchers on guard by
  [@lilibethdlc][github-user-lilibethdlc]
- Default rspec output to documentation and syntax to `expect` by
  [@gonzedge][github-user-gonzedge]
- Require `bundler/gem_tasks` instead of calling `install_tasks` directly by
  [@lilibethdlc][github-user-lilibethdlc]

## 0.5.1 [compare][compare-v0.5.0-and-v0.5.1]

### Enhancements

#### Major

- Extract file reading logic into own `PlainTextReader` object by
  [@gonzedge][github-user-gonzedge]
- Replace instance variables with attr accessors/writers by
  [@gonzedge][github-user-gonzedge]
      Including `#letter`, `#children`, `#terminal`

#### Minor

- Added `#inspect` documentation by [@gonzedge][github-user-gonzedge]
- Refactor `nil` check by [@gonzedge][github-user-gonzedge]
- Updated benchmark reports by [@gonzedge][github-user-gonzedge]

## 0.5.0 [compare][compare-v0.4.2-and-v0.5.0]

### Breaking Changes

- Removed deprecated `Rambling::Trie.new` entry point by
  [@gonzedge][github-user-gonzedge]
- Removed deprecated methods by [@gonzedge][github-user-gonzedge]
    Includes `#has_branch_for?`, `#is_word?` and `#add_branch_from`

### Enhancements

#### Major

- Yield created trie on `Rambling::Trie.create` by
  [@gonzedge][github-user-gonzedge]
- Add `Inspector` module for pretty printing by
  [@lilibethdlc][github-user-lilibethdlc]
- Rename `#has_branch?` to `#branch?` by [@gonzedge][github-user-gonzedge]
- Rename `#add_branch` to `#add` by [@gonzedge][github-user-gonzedge]
- Use faster string concatenation with `#<<` instead of `#+` by
  [@lilibethdlc][github-user-lilibethdlc]
- Add missing `InvalidOperation` exception messages by
  [@gonzedge][github-user-gonzedge]

#### Minor

- Configure specs to be run in random order by [@gonzedge][github-user-gonzedge]
- Default `word` to `nil` on `Node` initialization by [@gonzedge][github-user-gonzedge]
- Change required files list from array to `%w{}` by [@gonzedge][github-user-gonzedge]
- Change expectation syntax from `should` to `expect().to` by [@gonzedge][github-user-gonzedge]
- Upgrade development dependencies by [@gonzedge][github-user-gonzedge]

## 0.4.2 [compare][compare-v0.4.1-and-v0.4.2]

### Enhancements

#### Major

- Fix variable mutation on `Root#add_branch_for` [#6][github-issue-06] by
  [@gonzedge][github-user-gonzedge]
    - Defined `#<<` instead of alias for overriding purposes
- Add `Enumerable` capabilities [#5][github-issue-05] by
  [@gonzedge][github-user-gonzedge]
- Restructure file/directory tree again by [@gonzedge][github-user-gonzedge]
    Files now live under `lib/rambling/trie` instead of `lib/rambling-trie`

#### Minor

- Fix param name for `#create` and `#new` by [@gonzedge][github-user-gonzedge]
- Adding Travis CI configuration by [@gonzedge][github-user-gonzedge]

## 0.4.1 [compare][compare-v0.4.0-and-v0.4.1]

### Breaking Changes

- Move `ChildrenHashDeferer` to `Rambling::Trie` module by
  [@gonzedge][github-user-gonzedge]

### Enhancements

#### Major

- Add missing deprecation warning for `Rambling::Trie.new` by
  [@gonzedge][github-user-gonzedge]
- Add the `#<<` method to `Node` [#4][github-issue-04] by
  [@gonzedge][github-user-gonzedge]
- Add `#include?` method to `Root` [#3][github-issue-03] by
  [@gonzedge][github-user-gonzedge]

#### Minor

- Lowered complexity of `has_branch_for?` implementation for compressed by
  [@gonzedge][github-user-gonzedge]
- Minor performance improvements for compressed trie by
  [@gonzedge][github-user-gonzedge]
- Use new `#<<` method in place of `#add_branch_from` by
  [@gonzedge][github-user-gonzedge]

## 0.4.0 [compare][compare-v0.3.4-and-v0.4.0]

#### Major

- Create new `Rambling::Trie.create` API entry point by
  [@gonzedge][github-user-gonzedge]
- Changed gem name and directory structure to match standard by
  [@gonzedge][github-user-gonzedge]

#### Minor

- Update documentation for new entry point by [@gonzedge][github-user-gonzedge]
- Chang some `describe`s to `context` by [@gonzedge][github-user-gonzedge]
- Add bundler rake tasks by [@gonzedge][github-user-gonzedge]
- Updated gemspec to match standard style by [@gonzedge][github-user-gonzedge]
- Added perftools.rb to the mix (cpu profiling) by
  [@gonzedge][github-user-gonzedge]
- Removed unused variable by [@gonzedge][github-user-gonzedge]

## 0.3.4 [compare][compare-v0.3.3-and-v0.3.4]

## 0.3.3 [compare][compare-v0.3.2-and-v0.3.3]

## 0.3.2 [compare][compare-v0.3.1-and-v0.3.2]

## 0.3.1 [compare][compare-v0.3.0-and-v0.3.1]

## 0.3.0 [compare][compare-v0.2.0-and-v0.3.0]

## 0.2.0 [compare][compare-v0.1.0-and-v0.2.0]

## 0.1.0 [compare][compare-v0.0.2-and-v0.1.0]

## 0.0.2 [compare][compare-v0.0.1-and-v0.0.2]

## 0.0.1 [compare][compare-v0.0.0-and-v0.0.1]

[compare-v0.0.0-and-v0.0.1]: https://github.com/gonzedge/rambling-trie/compare/v0.0.0...v0.0.1
[compare-v0.0.1-and-v0.0.2]: https://github.com/gonzedge/rambling-trie/compare/v0.0.1...v0.0.2
[compare-v0.0.2-and-v0.1.0]: https://github.com/gonzedge/rambling-trie/compare/v0.0.2...v0.1.0
[compare-v0.1.0-and-v0.2.0]: https://github.com/gonzedge/rambling-trie/compare/v0.1.0...v0.2.0
[compare-v0.2.0-and-v0.3.0]: https://github.com/gonzedge/rambling-trie/compare/v0.2.0...v0.3.0
[compare-v0.3.0-and-v0.3.1]: https://github.com/gonzedge/rambling-trie/compare/v0.3.0...v0.3.1
[compare-v0.3.1-and-v0.3.2]: https://github.com/gonzedge/rambling-trie/compare/v0.3.1...v0.3.2
[compare-v0.3.2-and-v0.3.3]: https://github.com/gonzedge/rambling-trie/compare/v0.3.2...v0.3.3
[compare-v0.3.3-and-v0.3.4]: https://github.com/gonzedge/rambling-trie/compare/v0.3.3...v0.3.4
[compare-v0.3.4-and-v0.4.0]: https://github.com/gonzedge/rambling-trie/compare/v0.3.4...v0.4.0
[compare-v0.4.0-and-v0.4.1]: https://github.com/gonzedge/rambling-trie/compare/v0.4.0...v0.4.1
[compare-v0.4.1-and-v0.4.2]: https://github.com/gonzedge/rambling-trie/compare/v0.4.1...v0.4.2
[compare-v0.4.2-and-v0.5.0]: https://github.com/gonzedge/rambling-trie/compare/v0.4.2...v0.5.0
[compare-v0.5.0-and-v0.5.1]: https://github.com/gonzedge/rambling-trie/compare/v0.5.0...v0.5.1
[compare-v0.5.1-and-v0.5.2]: https://github.com/gonzedge/rambling-trie/compare/v0.5.1...v0.5.2
[compare-v0.5.2-and-v0.6.0]: https://github.com/gonzedge/rambling-trie/compare/v0.5.2...v0.6.0
[compare-v0.6.0-and-v0.6.1]: https://github.com/gonzedge/rambling-trie/compare/v0.6.0...v0.6.1
[compare-v0.6.1-and-v0.7.0]: https://github.com/gonzedge/rambling-trie/compare/v0.6.1...v0.7.0
[compare-v0.7.0-and-v0.7.0]: https://github.com/gonzedge/rambling-trie/compare/v0.7.0...v0.7.0
[compare-v0.7.0-and-v0.8.0]: https://github.com/gonzedge/rambling-trie/compare/v0.7.0...v0.8.0
[compare-v0.8.0-and-v0.8.1]: https://github.com/gonzedge/rambling-trie/compare/v0.8.0...v0.8.1
[compare-v0.8.1-and-v0.9.0]: https://github.com/gonzedge/rambling-trie/compare/v0.8.1...v0.9.0
[compare-v0.9.0-and-v0.9.1]: https://github.com/gonzedge/rambling-trie/compare/v0.9.0...v0.9.1
[compare-v0.9.1-and-v0.9.2]: https://github.com/gonzedge/rambling-trie/compare/v0.9.1...v0.9.2
[compare-v0.9.2-and-v0.9.3]: https://github.com/gonzedge/rambling-trie/compare/v0.9.2...v0.9.3
[compare-v0.9.3-and-master]: https://github.com/gonzedge/rambling-trie/compare/v0.9.3...master
[design-patterns-null-object]: http://wiki.c2.com/?NullObject
[github-commit-current-key-less-memory]: https://github.com/gonzedge/rambling-trie/commit/218fac218a77e70ba04a3672ff5abfddf6544f57
[github-commit-reduced-memory-footprint]: https://github.com/gonzedge/rambling-trie/commit/aa8c0262f888e88df6a2f1e1351d8f14b21e43c4
[github-issue-03]: https://github.com/gonzedge/rambling-trie/issues/3
[github-issue-04]: https://github.com/gonzedge/rambling-trie/issues/4
[github-issue-05]: https://github.com/gonzedge/rambling-trie/issues/5
[github-issue-06]: https://github.com/gonzedge/rambling-trie/issues/6
[github-issue-07]: https://github.com/gonzedge/rambling-trie/issues/7
[github-issue-08]: https://github.com/gonzedge/rambling-trie/issues/8
[github-issue-10]: https://github.com/gonzedge/rambling-trie/issues/10
[github-issue-11]: https://github.com/gonzedge/rambling-trie/issues/11
[github-user-gonzedge]: https://github.com/gonzedge
[github-user-lilibethdlc]: https://github.com/lilibethdlc
[ruby-bug-13111]: https://bugs.ruby-lang.org/issues/13111
