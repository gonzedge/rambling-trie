# CHANGELOG

## 2.4.1 [compare][compare_v2_4_0_and_master]

## 2.4.0 [compare][compare_v2_3_1_and_v2_4_0]

- Handle code inspections in `lib/` - use `%w` and `https` in gemspec by [@gonzedge][github_user_gonzedge]
  - And add explicit RubyMine `noinspection` comments for things that RuboCop already takes care of.
- Handle code inspections in `tasks/` by [@gonzedge][github_user_gonzedge]
  - Rename `Helpers::{GC => GarbageCollection}` (and corresponding files)
  - Use symbols for hash `key?`/`has_key?`/`!![]` ips benchmark comparison
- Use `RSpec::Config`'s `filter_run_when_matching` instead of deprecated `run_all_when_everything_filtered`
  by [@gonzedge][github_user_gonzedge]
  - Use non-reserved words for file format and method name so that we are not accidentally shadowing important
    built-ins (`:format` => `:file_format`, `:method` => `:method_name`)
  - Explicitly assert any new `Node` is not a `#word?` by default after initialization
  - Remove unnecessary parens from let definitions in specs
- Use `@return [self]` in `Node#terminal!` rubydoc by [@gonzedge][github_user_gonzedge]
  - Also fix typos in `CHANGELOG.md` and `CONTRIBUTING.md`
- Update `CallTreeProfiler` to use new `RubyProf::Profiler` format by [@gonzedge][github_user_gonzedge]

  Plus:

  - More accurate `pop`/`shift`/`slice!` reporting
  - Only require `benchmark/ips` when necessary
  - One-liner blocks
- Add version specs to ensure `README/CHANGELOG` update before release by [@gonzedge][github_user_gonzedge]
- Exclude `spec/` from `simplecov` coverage by [@gonzedge][github_user_gonzedge]

  ... by using the same filter as we use for `Coveralls.wear!`
- CodeClimate plugins by [@gonzedge][github_user_gonzedge]
  - `fixme`
    - And exclude `rubocop` files
  - `markdownlint`
    - Max line length is 120 (`MD013`)
    - Ordered list style is `ordered` (`MD029`)
    - Add titles to `CHANGELOG.md` and `CONTRIBUTING.md`
    - Apply lint rules
    - Fix corresponding tests
  - `rubocop`
    - Allow up to 5 params to be optional (same as max total params)
    - Change max line length to 120.
  - `flog`
- Add `semgrep` GitHub Action by [@gonzedge][github_user_gonzedge]
- Update copyright years by [@gonzedge][github_user_gonzedge]

## 2.3.1 [compare][compare_v2_3_0_and_v2_3_1]

- Fix `Rambling::Trie.load` docs in README by [@gonzedge][github_user_gonzedge]
- Destructure args hash before passing to performance rake task by [@gonzedge][github_user_gonzedge]
- Update copyright years by [@gonzedge][github_user_gonzedge]
- Attempt to clear gem version badge being cached by GitHub (?) by [@gonzedge][github_user_gonzedge]
- Migrate from TravisCI to SemaphoreCI by [@gonzedge][github_user_gonzedge]
- Be more lax with file size tests ([#26][github_pull_26]) by [@gonzedge][github_user_gonzedge]
- Add missing `compress!` in container spec ([#25][github_pull_25]) by [@gonzedge][github_user_gonzedge]
  - To actually test the non-matching tree shared example for compressed tries.
- Upgrade RuboCop and apply new rules ([#24][github_pull_24]) by [@gonzedge][github_user_gonzedge]
  - Issues found in `lib/` and `tasks/`
    1. Explicitly disable `Style/ExplicitBlockArgument` due to resulting performance hits
    2. Add missing `super`s
    3. Yoda-style conditionals
    4. Bump target ruby required version to current min supported (`2.7.0`)
  - Issues found in `spec/`
    1. Use `instance_double` instead of `double`
    2. Split tests into single-assertion specs when parameterization is possible; disable otherwise
    3. Use `let!` instead of instance variables
    4. Remove duplicate test groups
    5. Use `when` at the start of `context` block descriptions
    6. Use `described_class`, `subject` in specs where possible
    7. Single-line `before` where possible
  - Other
    1. Explicitly add `rubocop-performance`, `rubocop-rake`, `rubocop-rspec` plugins
    2. Remove unused `Rails` rules
    3. Remove unused/deprecated `RSpec`/`Layout`/`Style`/`Lint` rules
- More thorough serializer tests ([#28][github_pull_28]) by [@gonzedge][github_user_gonzedge]
  - Realized that, except for one integration test, we were not testing compressed tries being serialized so added some
    more specific use cases. Also took the chance to expand the zip serializer spec to handle all formats.
- Update badges, CI and test/coverage reporting ([#29][github_pull_29]) by [@gonzedge][github_user_gonzedge]
  - Correctly configure main task to publish test report, now being picked up by Semaphore
  - On badges:
    - Change `README.md` to have one badge per line instead of all in one giant line
    - Add RubyGems downloads badge
    - Add CodeClimate issues badge
    - Update docs badge to point directly to [rubydoc.info/gems/rambling-trie][rubydoc]
    - Update license badge to one from shields.io
- Use GitHub Actions for main branch and PR checks ([#30][github_pull_30], [#31][github_pull_31], [#32][github_pull_32])
  by [@gonzedge][github_user_gonzedge]
  - Run `build` action with `lint` for `rubocop`, `spec` for `rspec`, `coverage` for `coveralls`
  - Run `codeql` action
  - Run `dependency-review` action only on pull requests
- Reduce semaphore config to latest ruby ([#33][github_pull_33]) by [@gonzedge][github_user_gonzedge]
  - Now, we only care about top-level pass/fail for badge reporting. All other tests are run with GitHub Actions.
- Rename GitHub Actions and steps for better badges ([#34][github_pull_34]) by [@gonzedge][github_user_gonzedge]
  - Plus reformat badges at top of `README.md`.
- Add CodeClimate coverage step to build GH action ([#35][github_pull_35]) by [@gonzedge][github_user_gonzedge]
  - Do things differently for coveralls and code climate
  - Use correct shared example for `words_within?` on compressed tries
- Ensure all serializer `#dump` methods return the size of the file ([#36][github_pull_36]) by [@gonzedge][github_user_gonzedge]
  - Add test in `a serializer` shared examples
  - Implement method for `Rambling::Trie::Serializers::Zip`
- Ensure `#each`/`#each_word` return `Enumerator`/`self` ([#37][github_pull_37]) by [@gonzedge][github_user_gonzedge]
  - … depending on whether a block is given or not.
- Improve API documentation ([#38][github_pull_38]) by [@gonzedge][github_user_gonzedge]
  - Add `Readers::Reader` and `Serializer::Serializer` base classes
  - Make all readers/serializers extend from their corresponding base classes
  - Better docs with `Reader`/`Serializer` and generics
  - Fix all code blocks from backtick to `+` and add some more
  - Add `@return [void]` where appropriate
  - Add `@return [self]` where appropriate
  - Fix `Nodes::Node` duplicate and broken references
  - Fix some typos and add some missing periods
- Add explicit changelog and docs urls to `.gemspec` ([#39][github_pull_39]) by [@gonzedge][github_user_gonzedge]
  - Update `CHANGELOG.md` with latest changes

## 2.3.0 [compare][compare_v2_2_1_and_v2_3_0]

- Don't use `YAML.safe_load`'s legacy API by [@KitaitiMakoto][github_user_kitaitimakoto]
- Add explicit support for Ruby 3.1.x by [@KitaitiMakoto][github_user_kitaitimakoto]
- Add block to `Coveralls.wear!` to prevent `SimpleCove.start` being called twice by [@KitaitiMakoto][github_user_kitaitimakoto]
- Add explicit support for Ruby 3.2.x by [@agate][github_user_agate]
- Make sure gem also supports all the sub version of 3.2 by [@agate][github_user_agate]
  - Includes adding support for 2.7.{4,5,6,7}, 3.0.{2,3,4,5}, 3.1.{0,1,2,3} and 3.2.{0,1}
- Use new `coveralls_reborn` to support new ruby by [@agate][github_user_agate]
- Update `required_ruby_version` bounds to `>= 2.7, < 4` by [@gonzedge][github_user_gonzedge]
- Drop support for Ruby 2.5.x and 2.6.x by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.7.8, 3.0.6, 3.1.4, 3.2.2 to supported versions by [@gonzedge][github_user_gonzedge]
- Update documentation links to min required ruby version by [@gonzedge][github_user_gonzedge]

## 2.2.1 [compare][compare_v2_2_0_and_v2_2_1]

- Add support for Ruby 3.0.x by [@as181920][github_user_as181920]

## 2.2.0 [compare][compare_v2_1_1_and_v2_2_0]

- Bump min version to 2.5 by [@gonzedge][github_user_gonzedge]
- Add Ruby 3 to required Ruby versions by [@KitaitiMakoto][github_user_kitaitimakoto]

## 2.1.1 [compare][compare_v2_1_0_and_v2_1_1]

- Change `slice!` to `shift` (#16) by [@shinjiikeda][github_user_shinjiikeda]
- Frozen string issue fix by [@godsent][github_user_godsent]
- Drop Ruby 2.4.x; add 2.7 and updated 2.6.x/2.5.x support by [@gonzedge][github_user_gonzedge]
- Be more flexible with file sizes for zip file test by [@gonzedge][github_user_gonzedge]
- Upgrade development dependencies by [@gonzedge][github_user_gonzedge]
- Specify `ArgumentError` exception for provider collection spec by [@gonzedge][github_user_gonzedge]

## 2.1.0 [compare][compare_v2_0_0_and_v2_1_0]

- Add official support for Ruby 2.6 by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.5.{2,3,4,5} and 2.4{5,6} to supported versions by [@gonzedge][github_user_gonzedge]
- Require Ruby 2.4.x or up in gemspec by [@gonzedge][github_user_gonzedge]
- Remove official support for 2.3.x by [@gonzedge][github_user_gonzedge]

## 2.0.0 [compare][compare_v1_0_3_and_v2_0_0]

### Breaking Changes

- Remove `Container` deprecated methods by [@gonzedge][github_user_gonzedge]

  - `#as_word`
  - `#letter`
  - `#parent`
  - `#to_s`

- Require Ruby 2.3.x or up in gemspec by [@gonzedge][github_user_gonzedge]
- Drop Ruby 2.2.x support in favor of squiggly heredoc (`<<~`) by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

Most of these help with the gem's overall performance.

- Add Ruby 2.5.1, 2.4.4 and 2.3.7 to supported versions by [@gonzedge][github_user_gonzedge]
- Move `#partial_word?` and `#word?` up to `Node` by [@gonzedge][github_user_gonzedge]
- Use `Yaml.safe_load` in yaml serializer by [@gonzedge][github_user_gonzedge]
- Use `#each_key` and `#each_value` where appropriate by [@gonzedge][github_user_gonzedge]
- Extract `#deprecation_warning` method for `Container` by [@gonzedge][github_user_gonzedge]
- Stop using `#has_x?` method configuration by [@gonzedge][github_user_gonzedge]

#### Minor

- Remove unnecessary rake task file by [@gonzedge][github_user_gonzedge]
- Extract serialization tasks into their own classes by [@gonzedge][github_user_gonzedge]
- Regenerate serialized dictionaries every time by [@gonzedge][github_user_gonzedge]
- Change compression strategy and tree structure for `Compressed` nodes by [@gonzedge][github_user_gonzedge]
- Add ips dup vs clone vs slice benchmark by [@gonzedge][github_user_gonzedge]
- Improve documentation of `.dump`, `.load` and all `Serializers` by [@gonzedge][github_user_gonzedge]
- Exclude `Serializers::Marshal` from rubocop inspection by [@gonzedge][github_user_gonzedge]
- Add ips alias_method vs alias benchmark by [@gonzedge][github_user_gonzedge]
- Refactor rake tasks by [@gonzedge][github_user_gonzedge]
- Add `#not_change` matcher to simplify `ProviderCollection` spec by [@gonzedge][github_user_gonzedge]
- First big Rubocop sweep by [@gonzedge][github_user_gonzedge]
- Add rubocop by [@gonzedge][github_user_gonzedge]

## 1.0.3 [compare][compare_v1_0_2_and_v1_0_3]

### Breaking Changes

- Rename `Compressable` to more widely used `Compressible` by [@gonzedge][github_user_gonzedge]
- Add letter to `Node`'s constructor by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

Most of these help with the gem's overall performance.

- Add `#compress` method to public API by [@gonzedge][github_user_gonzedge]
- Add `#concat` method to public facing API by [@gonzedge][github_user_gonzedge]
- Define `ProviderCollection#format` method instead of alias for `#keys` by [@gonzedge][github_user_gonzedge]
- Remove unnecessary aliases and move necessary ones to private by [@gonzedge][github_user_gonzedge]
- Add `#has_letter?` alias for `#has_key?` by [@gonzedge][github_user_gonzedge]
- Add deprecation warnings for `Container`'s methods by [@gonzedge][github_user_gonzedge]
- Define delegate methods explicitly and remove dependency on `Forwardable` by [@gonzedge][github_user_gonzedge]
- Reverse char array and use `#pop` instead of slice when adding a word by [@gonzedge][github_user_gonzedge]
- Pull `#scan` up to `Node` by [@gonzedge][github_user_gonzedge]
- Slightly reduce memory for `Properties` and `ProviderCollection` classes by [@gonzedge][github_user_gonzedge]
- Use `#children_tree` instead of `#children` when possible by [@gonzedge][github_user_gonzedge]
- Remove unnecessary assignment in `#letter=` by [@gonzedge][github_user_gonzedge]
- Use `#each_value` instead of `#values`.`#each` in `Enumerable#each` by [@gonzedge][github_user_gonzedge]
- Use `#each_key` instead of `#keys`.`#each` in `CompressedNode#current_key` by [@gonzedge][github_user_gonzedge]
- Use `File.foreach` to read file on `Readers::PlainText` by [@gonzedge][github_user_gonzedge]
- Preemptively convert the word added to array of symbols by [@gonzedge][github_user_gonzedge]
- Pull gem require up to the Rakefile to avoid issues with `.load` method by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.5.0 support by [@gonzedge][github_user_gonzedge]

#### Minor

- Better name for classes in ips attr_accessor vs method benchmark task by [@gonzedge][github_user_gonzedge]
- Fix links in README by [@gonzedge][github_user_gonzedge]
- Require profiling libraries only when they are strictly necessary by [@gonzedge][github_user_gonzedge]
- Refactor trie integration tests by [@gonzedge][github_user_gonzedge]
- Refactor serializer tests by [@gonzedge][github_user_gonzedge]
- Extract shared examples for trie node implementations by [@gonzedge][github_user_gonzedge]
- Add missing documentation in `Configuration::Properties` by [@gonzedge][github_user_gonzedge]
- Update documentation to reflect actual side effects (or lack thereof) by [@gonzedge][github_user_gonzedge]
- Rename a few tests to maintain consistent wording by [@gonzedge][github_user_gonzedge]
- Add `#add_word` and `#add_words` helpers to avoid shotgun surgery in tests by [@gonzedge][github_user_gonzedge]
- Use real node for `Container#each` test by [@gonzedge][github_user_gonzedge]
- Add documentation for `ProviderCollection`'s `#keys` and `#[]` by [@gonzedge][github_user_gonzedge]
- Upgrade to coveralls 0.8.21 by [@gonzedge][github_user_gonzedge]
- Add documentation for delegate methods and fix Node specs by [@gonzedge][github_user_gonzedge]
- Fix wrong documentation links by [@gonzedge][github_user_gonzedge]
- Add ips rake task namespace for benchmark-ips results by [@gonzedge][github_user_gonzedge]
- Add Pry to development dependencies for debugging purposes by [@gonzedge][github_user_gonzedge]
- Derive filename from task's name by [@gonzedge][github_user_gonzedge]
- Complete overhaul of performance task directory structure by [@gonzedge][github_user_gonzedge]
- Refactor `Compressor` and improve memory footprint and performance by [@gonzedge][github_user_gonzedge]
- Move all `Node`s into 'nodes/' directory by [@gonzedge][github_user_gonzedge]

## 1.0.2 [compare][compare_v1_0_1_and_v1_0_2]

- Drop Ruby 2.1.x support by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.4.{2,3}, 2.3.{5,6} 2.2.{8,9} to supported versions by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.3.4 and 2.2.7 to supported versions by [@gonzedge][github_user_gonzedge]

## 1.0.1 [compare][compare_v1_0_0_and_v1_0_1]

- Use Ruby's own `Forwardable` again by [@gonzedge][github_user_gonzedge]
- Remove CodeClimate test reporter by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.4.1 to supported versions by [@gonzedge][github_user_gonzedge]

## 1.0.0 [compare][compare_v0_9_3_and_v1_0_0]

### Breaking Changes

- Rename `PlainTextReader` to `Readers::PlainText` by [@gonzedge][github_user_gonzedge]
- Rename `Compression` to `Compressable` by [@gonzedge][github_user_gonzedge]
- Rename `Inspect` to `Inspectable` by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Add `Serializers` to dump trie into/load trie from disk
  [#10][github_issue_10] by [@gonzedge][github_user_gonzedge]

  - Supported formats include Ruby's `Marshal` (`.marshal`) with
    `Serializers::Marshal` and `YAML` (`.yaml` or `.yml`) with
    `Serializers::Yaml`
  - The format to use is determined by the filepath extension and
    `Marshal` is used when a format isn't recognized.

  ``` ruby
  # Save `your_trie` into a file
  Rambling::Trie.dump your_trie, 'a filename'

  # Load a trie from a file into memory
  trie = Rambling::Trie.load 'a filename'
  ```

- Add `Serializers::Zip` to handle zip files by
  [@gonzedge][github_user_gonzedge]

  Automatically detects `.marshal` and `.yaml` files, as well as any
  configured `Serializer` based on filepath extension

- Add ability to configure `rambling-trie` [#11][github_issue_11]
  by [@gonzedge][github_user_gonzedge]

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

- Add `#words_within` and `#words_within?` to get all words matched within a
  given string [#9][github_issue_09] by [@gonzedge][github_user_gonzedge]

  - `#words_within` returns all the matched words
  - `#words_within?` returns `true` as soon as it finds one matching word

- Add `#==` to compare nodes by [@gonzedge][github_user_gonzedge]

  Contained in `Rambling::Trie::Comparable` module. Two nodes are equal to
  each other if they have the same letter, they are both either terminal or
  non-terminal and their children tree is the same

- Add changelog by [@gonzedge][github_user_gonzedge]
- Add contributing guide by [@gonzedge][github_user_gonzedge]

#### Minor

- Extract modules for peripheral node functionality by [@gonzedge][github_user_gonzedge]

  - Move `#to_s` to `Stringifyable` module
  - Move `#as_word` to `Stringifyable` module by
  - Move `#==` to `Comparable` module
  - Rename `Compression` to `Compressable`
  - Rename `Inspector` to `Inspectable`

- Add `#terminal?` value to inspect output by [@gonzedge][github_user_gonzedge]
- Display value of `#terminal` instead of `#terminal?` when `Node` is inspected
  by [@gonzedge][github_user_gonzedge]
- Freeze `Rambling::Trie::VERSION` by [@gonzedge][github_user_gonzedge]
- Refactor performance instrumentation tasks by
  [@gonzedge][github_user_gonzedge]

  - Add `Performance` module
  - Add `Performance::Reporter` & `Performance::Directory` classes
  - Move task execution into individual classes
  - Unify all tasks into single entry point `rake performance[type,method]`

- Change benchmark report format by [@gonzedge][github_user_gonzedge]
- Correct supported versions by [@gonzedge][github_user_gonzedge]
- Only create new `Reader` instance when filepath is given on initialization by
  [@gonzedge][github_user_gonzedge]
- Update license year by [@gonzedge][github_user_gonzedge]

## 0.9.3 [compare][compare_v0_9_2_and_v0_9_3]

### Enhancements

#### Major

- Add Ruby 2.4 to supported versions by [@gonzedge][github_user_gonzedge]
- Drastically reduce size of gem by [@gonzedge][github_user_gonzedge]
  - By excluding unnecessary `assets/` and `reports/` when building the gem.
  - **Size reduction**: from ~472KB to ~21KB.
- Make root node accessible via container by [@gonzedge][github_user_gonzedge]
  - So that anyone using rambling-trie can develop their custom algorithms
- Expose root node's `#to_a` method through `Container` by
  [@gonzedge][github_user_gonzedge]
- Add own `Forwardable#delegate` because of [Ruby 2.4 performance
  degradation][ruby_bug_13111] by [@gonzedge][github_user_gonzedge]
  - Was able to take Creation and Compression benchmarks (~8.8s and ~1.5s
  respectively) back down to the Ruby 2.3.3 levels by adding own definition of
  `Forwardable#delegate`.

#### Minor

- Ensure unicode words are supported by [@gonzedge][github_user_gonzedge]
- Add flamegraph reports to performance instrumentation tasks by
  [@gonzedge][github_user_gonzedge]
- Move benchmark/profiling dependencies from gemspec to Gemfile by
  [@gonzedge][github_user_gonzedge]
- Add missing docs by [@gonzedge][github_user_gonzedge]
- Improvements on TravisCI setup by [@gonzedge][github_user_gonzedge]
- Add CodeClimate test coverage integration by
  [@gonzedge][github_user_gonzedge]
- Move rspec config from .rspec to spec_helper by
  [@gonzedge][github_user_gonzedge]

## 0.9.2 [compare][compare_v0_9_1_and_v0_9_2]

### Enhancements

#### Major

- Fix "undefined method `to_sym`" on compressed trie's `#partial_word?` and
  `#scan` by [@gonzedge][github_user_gonzedge]
- Expose all usable `Node` methods in `Container` through delegation by
  [@gonzedge][github_user_gonzedge]

  - Expose `#as_word`
  - Expose `#children`
  - Expose `#children_tree`
  - Expose `#has_key?`
  - Expose `#parent`
  - Expose `#size`
  - Expose `#to_s`

#### Minor

- Unify `#scan` implementation between `Raw` and `Compressed` node by
  [@gonzedge][github_user_gonzedge]

## 0.9.1 [compare][compare_v0_9_0_and_v0_9_1]

### Enhancements

#### Major

- Performance improvements for all trie operations by
  [@gonzedge][github_user_gonzedge]
- Reduce memory footprint without affecting performance for compressed node
  operations by [@gonzedge][github_user_gonzedge]

  Including `#word?`, `#partial_word?` and `#closest_node`. See these commits
  for more info:

  - [aa8c0262f888e88df6a2f1e1351d8f14b21e43c4][github_commit_reduced_memory_footprint]
  - [218fac218a77e70ba04a3672ff5abfddf6544f57][github_commit_current_key_less_memory]

#### Minor

- Make trie integration test a bit faster by [@gonzedge][github_user_gonzedge]
- Remove unnecessary `#to_a` calls from `Container` by
  [@gonzedge][github_user_gonzedge]
- Extract `#recursive_get` to unify `#partial_word?` and `#scan`
  implementations by [@gonzedge][github_user_gonzedge]
- Better `#word?` implementation for compressed node by
  [@gonzedge][github_user_gonzedge]
- Rename `new_letter` => `letter` by [@gonzedge][github_user_gonzedge]
- Further performance instrumentation improvements by
  [@gonzedge][github_user_gonzedge]
- Split out benchmark reports per version by [@gonzedge][github_user_gonzedge]

## 0.9.0 [compare][compare_v0_8_1_and_v0_9_0]

### Breaking Changes

- `Rambling::Trie.create` now returns a `Container` instead of a `Root` by
  [@gonzedge][github_user_gonzedge]
  - `Container` exposes these API entry points:
    - `#partial_word?` and its alias `#match?`
    - `#word?` and its alias `#include?`
    - `#add` and its alias `#<<`
    - yield the constructed `Container` on `#initialize`
  - `Rambling::Trie::Node` and its subclasses no longer expose:
    - `#match?`
    - `#include?`
    - `#<<`
    - yield on `#initialize`

- Remove `Branches` module, all of its behavior is now contained in `RawNode`
  and `CompressedNode` by [@gonzedge][github_user_gonzedge]
- Rename `Compressor` module to `Compression` (`Compressor` is now the class
  that transforms between a `RawNode` and a `CompressedNode`) by
  [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Separate uncompressed trie vs compressed trie logic into separate objects by
  [@gonzedge][github_user_gonzedge]

  - Create separate `RawNode` and `CompressedNode` classes
  - Add `Compressor` for `#compress!` implementation that maps from a
    `RawNode` to a `CompressedNode`

- Add `#terminal!` to `Node` to force node to be terminal by
  [@gonzedge][github_user_gonzedge]
- Move `#root?` into `Node` by [@gonzedge][github_user_gonzedge]
- Improve memory footprint of compressed trie (`CompressedNode`) by
  [@gonzedge][github_user_gonzedge]
- Small memory improvements to `RawNode` by [@gonzedge][github_user_gonzedge]
- Improve `Rambling::Trie::Enumerable` performance, hence `#scan` performance
  by [@gonzedge][github_user_gonzedge]
- Improve performance for `#scan` by [@gonzedge][github_user_gonzedge]
- Additional performance improvements for raw and compressed nodes operations
  by [@gonzedge][github_user_gonzedge]
- Improve trie creation performance by [@gonzedge][github_user_gonzedge]
- Improve performance of trie initialization from file by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Delegate `#inspect` to `#root` node by [@gonzedge][github_user_gonzedge]
- Rename `first_letter` to `letter` in `RawNode` by
  [@gonzedge][github_user_gonzedge]
- Expand performance instrumentation by [@gonzedge][github_user_gonzedge]

  Include memory profiles, call tree profiles and benchmark measurements for
  `#scan` method

## 0.8.1 [compare][compare_v0_8_0_and_v0_8_1]

### Enhancements

#### Major

- Fix `NoMethodError` missing branch from compressed root [#8][github_issue_08]
  by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.2.5, 2.2.6, 2.3.1, 2.3.2 and 2.3.3 to supported versions by
  [@gonzedge][github_user_gonzedge]

## 0.8.0 [compare][compare_v0_7_0_and_v0_8_0]

### Breaking Changes

- Drop support for Ruby 1.9.x and 2.0.x by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Add `#scan` method and its alias `#words` to find all words that match a
  given partial word [#7][github_issue_07] by [@gonzedge][github_user_gonzedge]

  - Return matching `Node`
  - Use [Null Object pattern][design_patterns_null_object] to return empty
    array with `Rambling::Trie::MissingNode`

- Add Ruby 2.1.6, 2.1.7, 2.1.8, 2.2.1, 2.2.2, 2.2.3, 2.2.4, and 2.3.0 to
  supported versions by [@gonzedge][github_user_gonzedge]

#### Minor

- Update license date by [@gonzedge][github_user_gonzedge]

## 0.7.0 [compare][compare_v0_6_1_and_v0_7_0]

### Breaking Changes

- Remove deprecated `#branch?` method by [@gonzedge][github_user_gonzedge]
- Drop support for Ruby 1.9.2 by [@gonzedge][github_user_gonzedge]
- Remove Rails version specification (not relevant) by
  [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Add Ruby 2.1.0, 2.1.1, 2.1.2, 2.1.3, 2.1.4, 2.1.5 to supported versions by
  [@gonzedge][github_user_gonzedge]
- Upgrade to RSpec 3 [@gonzedge][github_user_gonzedge]

  - Update gem dependencies and be more restrictive about gem dependency
    versions
  - Update other dev dependencies
  - Use RSpec's new syntax for message expectations

- Add LICENSE to gemspec by [@gonzedge][github_user_gonzedge]

#### Minor

- Update license by [@gonzedge][github_user_gonzedge]
- Explicitly define `#<<` alias for `#add` by [@gonzedge][github_user_gonzedge]

  This avoids having to call `.alias_method` again for
  `#add` method overloads.

## 0.6.1 [compare][compare_v0_6_0_and_v0_6_1]

### Enhancements

#### Major

- Performance improvements on uncompressed `#word?` and `#partial_word?` by
  [@gonzedge][github_user_gonzedge]

## 0.6.0 [compare][compare_v0_5_2_and_v0_6_0]

### Breaking Changes

- Change return value of `#children` by [@gonzedge][github_user_gonzedge]

   Returns the array of child nodes instead of the `Hash` representing the tree
   of children

- Rename `#branch?` method to `#partial_word?` by [@gonzedge][github_user_gonzedge]
- Rename old `#children` method to `#children_tree` by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Add `#root?` method by [@gonzedge][github_user_gonzedge]
- Add Ruby 2.0.0 to supported versions by [@gonzedge][github_user_gonzedge]

#### Minor

- Remove perftools.rb dependency by [@gonzedge][github_user_gonzedge]
- Use `Forwardable` instead of own delegator by [@gonzedge][github_user_gonzedge]
- Specify 'MIT License' in the license file by [@gonzedge][github_user_gonzedge]
- Update license year by [@gonzedge][github_user_gonzedge]

## 0.5.2 [compare][compare_v0_5_1_and_v0_5_2]

### Enhancements

#### Major

- Add `#to_s` method for node by [@gonzedge][github_user_gonzedge]

#### Minor

- Safer `#letter=` implementation by [@gonzedge][github_user_gonzedge]
- Refactor `#as_word` to use `#to_s` by [@gonzedge][github_user_gonzedge]
- Change spec format and remove rails matchers on guard by
  [@lilibethdlc][github_user_lilibethdlc]
- Default rspec output to documentation and syntax to `expect` by
  [@gonzedge][github_user_gonzedge]
- Require `bundler/gem_tasks` instead of calling `install_tasks` directly by
  [@lilibethdlc][github_user_lilibethdlc]

## 0.5.1 [compare][compare_v0_5_0_and_v0_5_1]

### Enhancements

#### Major

- Extract file reading logic into own `PlainTextReader` object by
  [@gonzedge][github_user_gonzedge]
- Replace instance variables with attr accessors/writers by
  [@gonzedge][github_user_gonzedge]

  Including `#letter`, `#children`, `#terminal`

#### Minor

- Add `#inspect` documentation by [@gonzedge][github_user_gonzedge]
- Refactor `nil` check by [@gonzedge][github_user_gonzedge]
- Update benchmark reports by [@gonzedge][github_user_gonzedge]

## 0.5.0 [compare][compare_v0_4_2_and_v0_5_0]

### Breaking Changes

- Remove deprecated `Rambling::Trie.new` entry point by
  [@gonzedge][github_user_gonzedge]
- Remove deprecated methods by [@gonzedge][github_user_gonzedge]

  Includes `#has_branch_for?`, `#is_word?` and `#add_branch_from`

### Enhancements

#### Major

- Yield created trie on `Rambling::Trie.create` by
  [@gonzedge][github_user_gonzedge]
- Add `Inspector` module for pretty printing by
  [@lilibethdlc][github_user_lilibethdlc]
- Rename `#has_branch?` to `#branch?` by [@gonzedge][github_user_gonzedge]
- Rename `#add_branch` to `#add` by [@gonzedge][github_user_gonzedge]
- Use faster string concatenation with `#<<` instead of `#+` by
  [@lilibethdlc][github_user_lilibethdlc]
- Add missing `InvalidOperation` exception messages by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Configure specs to be run in random order by [@gonzedge][github_user_gonzedge]
- Default `word` to `nil` on `Node` initialization by [@gonzedge][github_user_gonzedge]
- Change required files list from array to `%w{}` by [@gonzedge][github_user_gonzedge]
- Change expectation syntax from `should` to `expect().to` by [@gonzedge][github_user_gonzedge]
- Upgrade development dependencies by [@gonzedge][github_user_gonzedge]

## 0.4.2 [compare][compare_v0_4_1_and_v0_4_2]

### Enhancements

#### Major

- Fix variable mutation on `Root#add_branch_for` [#6][github_issue_06] by
  [@gonzedge][github_user_gonzedge]

  - Define `#<<` instead of alias for overriding purposes

- Add `Enumerable` capabilities [#5][github_issue_05] by
  [@gonzedge][github_user_gonzedge]
- Restructure file/directory tree again by [@gonzedge][github_user_gonzedge]

  Files now live under `lib/rambling/trie` instead of `lib/rambling-trie`

#### Minor

- Fix param name for `#create` and `#new` by [@gonzedge][github_user_gonzedge]
- Adding Travis CI configuration by [@gonzedge][github_user_gonzedge]

## 0.4.1 [compare][compare_v0_4_0_and_v0_4_1]

### Breaking Changes

- Move `ChildrenHashDeferer` to `Rambling::Trie` module by
  [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Add missing deprecation warning for `Rambling::Trie.new` by
  [@gonzedge][github_user_gonzedge]
- Add the `#<<` method to `Node` [#4][github_issue_04] by
  [@gonzedge][github_user_gonzedge]
- Add `#include?` method to `Root` [#3][github_issue_03] by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Lower complexity of `has_branch_for?` implementation for compressed by
  [@gonzedge][github_user_gonzedge]
- Minor performance improvements for compressed trie by
  [@gonzedge][github_user_gonzedge]
- Use new `#<<` method in place of `#add_branch_from` by
  [@gonzedge][github_user_gonzedge]

## 0.4.0 [compare][compare_v0_3_4_and_v0_4_0]

### Enhancements

#### Major

- Create new `Rambling::Trie.create` API entry point by
  [@gonzedge][github_user_gonzedge]
- Change gem name and directory structure to match standard by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Update documentation for new entry point by [@gonzedge][github_user_gonzedge]
- Chang some `describe`s to `context` by [@gonzedge][github_user_gonzedge]
- Add bundler rake tasks by [@gonzedge][github_user_gonzedge]
- Update gemspec to match standard style by [@gonzedge][github_user_gonzedge]
- Add perftools.rb to the mix (cpu profiling) by
  [@gonzedge][github_user_gonzedge]
- Remove unused variable by [@gonzedge][github_user_gonzedge]

## 0.3.4 [compare][compare_v0_3_3_and_v0_3_4]

### Enhancements

#### Major

- Fix issue with `Rambling::Trie` class definition by
  [@gonzedge][github_user_gonzedge]
- Performance improvement on `#has_branch_for?` by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Add guard to Gemfile by [@gonzedge][github_user_gonzedge]
- Add simplecov for code coverage by [@gonzedge][github_user_gonzedge]
- Refactor rambling-trie requires by [@gonzedge][github_user_gonzedge]
- Remove unnecessary internal `#trie_node` by [@gonzedge][github_user_gonzedge]
- Refactor specs to "The RSpec Way" by [@gonzedge][github_user_gonzedge]
- Add new benchmarking report info by [@gonzedge][github_user_gonzedge]
- Update RubyDoc.info link and compression info by [@gonzedge][github_user_gonzedge]

## 0.3.3 [compare][compare_v0_3_2_and_v0_3_3]

### Enhancements

#### Major

- Performance improvements for compressed and uncompressed tries by
  [@gonzedge][github_user_gonzedge]
- Add API documentation link (rubydoc.info - yard) by
  [@gonzedge][github_user_gonzedge]
- Add yard and redcarpet to development dependencies by
  [@gonzedge][github_user_gonzedge]
- Add inline documentation for rambling-trie by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Minor refactoring by [@gonzedge][github_user_gonzedge]
- Improve `#has_branch_for?` for compressed trie by
  [@gonzedge][github_user_gonzedge]
- Update README info for `has_branch_for?` method by [@gonzedge][github_user_gonzedge]

## 0.3.2 [compare][compare_v0_3_1_and_v0_3_2]

### Enhancements

#### Major

- Fix bug when adding terminal word that exists as non-terminal node
  [#2][github_issue_02] by [@gonzedge][github_user_gonzedge]
- Fix `#has_branch_for?` for compressed trie [#2][github_issue_02] by
  [@gonzedge][github_user_gonzedge]
- Fix `#is_word?` method for compressed trie [#2][github_issue_02] by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Refactor branch methods and improve performance a bit by
  [@gonzedge][github_user_gonzedge]
- Add performance report file by [@gonzedge][github_user_gonzedge]
- Add performance report file appending by [@gonzedge][github_user_gonzedge]

## 0.3.1 [compare][compare_v0_3_0_and_v0_3_1]

### Enhancements

#### Major

- Include version on gemspec from version file by
  [@gonzedge][github_user_gonzedge]
- Restrict `#compress!` to `Root` by [@gonzedge][github_user_gonzedge]
- Move branches logic to own `Branches` module by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Add first rake tasks and version file by [@gonzedge][github_user_gonzedge]
- Add performance report tasks by [@gonzedge][github_user_gonzedge]

## 0.3.0 [compare][compare_v0_2_0_and_v0_3_0]

### Enhancements

#### Major

- Add LICENSE by [@gonzedge][github_user_gonzedge]
- Handle empty string edge case by [@gonzedge][github_user_gonzedge]
- Performance gain replacing `block.call` with `Object.send` by
  [@gonzedge][github_user_gonzedge]

#### Minor

- Refactor `Compressor` by [@gonzedge][github_user_gonzedge]
- Remove `Gemfile.lock` to avoid hard dependencies by
  [@gonzedge][github_user_gonzedge]

## 0.2.0 [compare][compare_v0_1_0_and_v0_2_0]

### Breaking Changes

- Return self after compression by [@gonzedge][github_user_gonzedge]
- Change `#letter` from string to symbol by [@gonzedge][github_user_gonzedge]
- Use symbols instead of strings for letters and hash keys by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Do not compress terminal nodes by [@gonzedge][github_user_gonzedge]
- Add `#parent` attribute by [@gonzedge][github_user_gonzedge]
- Add `#terminal?` by [@gonzedge][github_user_gonzedge]
- Add `#compress!` by [@gonzedge][github_user_gonzedge]
- Add `#compressed?` by [@gonzedge][github_user_gonzedge]
- Read file line by line instead of loading it all into memory by
  [@gonzedge][github_user_gonzedge]
- Add `ChildrenHashDeferer` and `TrieCompressor` modules by
  [@gonzedge][github_user_gonzedge]

  Results of refactoring compression and hash methods

- Remove `#word` caching for memory gains by [@gonzedge][github_user_gonzedge]

#### Minor

- Added `#transfer_ownership` method by [@gonzedge][github_user_gonzedge]

## 0.1.0 [compare][compare_v0_0_2_and_v0_1_0]

### Breaking Changes

- Rename `#has_branch_tree?` to `#has_branch_for?` by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Added project README by [@gonzedge][github_user_gonzedge]

#### Minor

- Set minimum RSpec version to 2.0.0 by [@gonzedge][github_user_gonzedge]

## 0.0.2 [compare][compare_v0_0_1_and_v0_0_2]

### Breaking Changes

- Make `#get_parent_letter_string` protected by [@gonzedge][github_user_gonzedge]

### Enhancements

#### Major

- Fix empty and nil letter edge case and tests by [@gonzedge][github_user_gonzedge]
- Add the word caching for terminal nodes by [@gonzedge][github_user_gonzedge]
- Add `#as_word` by [@gonzedge][github_user_gonzedge]
- Add `InvalidTrieOperation` by [@gonzedge][github_user_gonzedge]

## 0.0.1 [compare][compare_v0_0_0_and_v0_0_1]

### Enhancements

#### Major

- Add the `Rambling` module for namespacing by [@gonzedge][github_user_gonzedge]
- Add `TrieNode` by [@gonzedge][github_user_gonzedge]
- Add `#is_word?` method by [@gonzedge][github_user_gonzedge]
- Add `#has_branch_tree?` by [@lilibethdlc][github_user_lilibethdlc]
- Add methods `#[]` and `#has_key?` to trie node by
  [@gonzedge][github_user_gonzedge]
- Add gemspec info draft by [@gonzedge][github_user_gonzedge]
- Adding correct bundle install source by [@lilibethdlc][github_user_lilibethdlc]

#### Minor

- Revising add branch recursion by [@lilibethdlc][github_user_lilibethdlc]

[compare_v0_0_0_and_v0_0_1]: https://github.com/gonzedge/rambling-trie/compare/v0.0.0...v0.0.1
[compare_v0_0_1_and_v0_0_2]: https://github.com/gonzedge/rambling-trie/compare/v0.0.1...v0.0.2
[compare_v0_0_2_and_v0_1_0]: https://github.com/gonzedge/rambling-trie/compare/v0.0.2...v0.1.0
[compare_v0_1_0_and_v0_2_0]: https://github.com/gonzedge/rambling-trie/compare/v0.1.0...v0.2.0
[compare_v0_2_0_and_v0_3_0]: https://github.com/gonzedge/rambling-trie/compare/v0.2.0...v0.3.0
[compare_v0_3_0_and_v0_3_1]: https://github.com/gonzedge/rambling-trie/compare/v0.3.0...v0.3.1
[compare_v0_3_1_and_v0_3_2]: https://github.com/gonzedge/rambling-trie/compare/v0.3.1...v0.3.2
[compare_v0_3_2_and_v0_3_3]: https://github.com/gonzedge/rambling-trie/compare/v0.3.2...v0.3.3
[compare_v0_3_3_and_v0_3_4]: https://github.com/gonzedge/rambling-trie/compare/v0.3.3...v0.3.4
[compare_v0_3_4_and_v0_4_0]: https://github.com/gonzedge/rambling-trie/compare/v0.3.4...v0.4.0
[compare_v0_4_0_and_v0_4_1]: https://github.com/gonzedge/rambling-trie/compare/v0.4.0...v0.4.1
[compare_v0_4_1_and_v0_4_2]: https://github.com/gonzedge/rambling-trie/compare/v0.4.1...v0.4.2
[compare_v0_4_2_and_v0_5_0]: https://github.com/gonzedge/rambling-trie/compare/v0.4.2...v0.5.0
[compare_v0_5_0_and_v0_5_1]: https://github.com/gonzedge/rambling-trie/compare/v0.5.0...v0.5.1
[compare_v0_5_1_and_v0_5_2]: https://github.com/gonzedge/rambling-trie/compare/v0.5.1...v0.5.2
[compare_v0_5_2_and_v0_6_0]: https://github.com/gonzedge/rambling-trie/compare/v0.5.2...v0.6.0
[compare_v0_6_0_and_v0_6_1]: https://github.com/gonzedge/rambling-trie/compare/v0.6.0...v0.6.1
[compare_v0_6_1_and_v0_7_0]: https://github.com/gonzedge/rambling-trie/compare/v0.6.1...v0.7.0
[compare_v0_7_0_and_v0_7_0]: https://github.com/gonzedge/rambling-trie/compare/v0.7.0...v0.7.0
[compare_v0_7_0_and_v0_8_0]: https://github.com/gonzedge/rambling-trie/compare/v0.7.0...v0.8.0
[compare_v0_8_0_and_v0_8_1]: https://github.com/gonzedge/rambling-trie/compare/v0.8.0...v0.8.1
[compare_v0_8_1_and_v0_9_0]: https://github.com/gonzedge/rambling-trie/compare/v0.8.1...v0.9.0
[compare_v0_9_0_and_v0_9_1]: https://github.com/gonzedge/rambling-trie/compare/v0.9.0...v0.9.1
[compare_v0_9_1_and_v0_9_2]: https://github.com/gonzedge/rambling-trie/compare/v0.9.1...v0.9.2
[compare_v0_9_2_and_v0_9_3]: https://github.com/gonzedge/rambling-trie/compare/v0.9.2...v0.9.3
[compare_v0_9_3_and_v1_0_0]: https://github.com/gonzedge/rambling-trie/compare/v0.9.3...v1.0.0
[compare_v1_0_0_and_v1_0_1]: https://github.com/gonzedge/rambling-trie/compare/v1.0.0...v1.0.1
[compare_v1_0_1_and_v1_0_2]: https://github.com/gonzedge/rambling-trie/compare/v1.0.1...v1.0.2
[compare_v1_0_2_and_v1_0_3]: https://github.com/gonzedge/rambling-trie/compare/v1.0.2...v1.0.3
[compare_v1_0_3_and_v2_0_0]: https://github.com/gonzedge/rambling-trie/compare/v1.0.3...v2.0.0
[compare_v2_0_0_and_v2_1_0]: https://github.com/gonzedge/rambling-trie/compare/v2.0.0...v2.1.0
[compare_v2_1_0_and_v2_1_1]: https://github.com/gonzedge/rambling-trie/compare/v2.1.0...v2.1.1
[compare_v2_1_1_and_v2_2_0]: https://github.com/gonzedge/rambling-trie/compare/v2.1.1...v2.2.0
[compare_v2_2_0_and_v2_2_1]: https://github.com/gonzedge/rambling-trie/compare/v2.2.0...v2.2.1
[compare_v2_2_1_and_v2_3_0]: https://github.com/gonzedge/rambling-trie/compare/v2.2.1...v2.3.0
[compare_v2_3_0_and_v2_3_1]: https://github.com/gonzedge/rambling-trie/compare/v2.3.0...v2.3.1
[compare_v2_3_1_and_v2_4_0]: https://github.com/gonzedge/rambling-trie/compare/v2.3.1...v2.4.0
[compare_v2_4_0_and_master]: https://github.com/gonzedge/rambling-trie/compare/v2.4.0...master
[design_patterns_null_object]: http://wiki.c2.com/?NullObject
[github_commit_current_key_less_memory]: https://github.com/gonzedge/rambling-trie/commit/218fac218a77e70ba04a3672ff5abfddf6544f57
[github_commit_reduced_memory_footprint]: https://github.com/gonzedge/rambling-trie/commit/aa8c0262f888e88df6a2f1e1351d8f14b21e43c4
[github_issue_02]: https://github.com/gonzedge/rambling-trie/issues/2
[github_issue_03]: https://github.com/gonzedge/rambling-trie/issues/3
[github_issue_04]: https://github.com/gonzedge/rambling-trie/issues/4
[github_issue_05]: https://github.com/gonzedge/rambling-trie/issues/5
[github_issue_06]: https://github.com/gonzedge/rambling-trie/issues/6
[github_issue_07]: https://github.com/gonzedge/rambling-trie/issues/7
[github_issue_08]: https://github.com/gonzedge/rambling-trie/issues/8
[github_issue_09]: https://github.com/gonzedge/rambling-trie/issues/9
[github_issue_10]: https://github.com/gonzedge/rambling-trie/issues/10
[github_issue_11]: https://github.com/gonzedge/rambling-trie/issues/11
[github_pull_16]: https://github.com/gonzedge/rambling-trie/pull/16
[github_pull_17]: https://github.com/gonzedge/rambling-trie/pull/17
[github_pull_18]: https://github.com/gonzedge/rambling-trie/pull/18
[github_pull_19]: https://github.com/gonzedge/rambling-trie/pull/19
[github_pull_20]: https://github.com/gonzedge/rambling-trie/pull/20
[github_pull_21]: https://github.com/gonzedge/rambling-trie/pull/21
[github_pull_22]: https://github.com/gonzedge/rambling-trie/pull/22
[github_pull_23]: https://github.com/gonzedge/rambling-trie/pull/23
[github_pull_24]: https://github.com/gonzedge/rambling-trie/pull/24
[github_pull_25]: https://github.com/gonzedge/rambling-trie/pull/25
[github_pull_26]: https://github.com/gonzedge/rambling-trie/pull/26
[github_pull_27]: https://github.com/gonzedge/rambling-trie/pull/27
[github_pull_28]: https://github.com/gonzedge/rambling-trie/pull/28
[github_pull_29]: https://github.com/gonzedge/rambling-trie/pull/29
[github_pull_30]: https://github.com/gonzedge/rambling-trie/pull/30
[github_pull_31]: https://github.com/gonzedge/rambling-trie/pull/31
[github_pull_32]: https://github.com/gonzedge/rambling-trie/pull/32
[github_pull_33]: https://github.com/gonzedge/rambling-trie/pull/33
[github_pull_34]: https://github.com/gonzedge/rambling-trie/pull/34
[github_pull_35]: https://github.com/gonzedge/rambling-trie/pull/35
[github_pull_36]: https://github.com/gonzedge/rambling-trie/pull/36
[github_pull_37]: https://github.com/gonzedge/rambling-trie/pull/37
[github_pull_38]: https://github.com/gonzedge/rambling-trie/pull/38
[github_pull_39]: https://github.com/gonzedge/rambling-trie/pull/39
[github_user_agate]: https://github.com/agate
[github_user_as181920]: https://github.com/as181920
[github_user_godsent]: https://github.com/godsent
[github_user_gonzedge]: https://github.com/gonzedge
[github_user_kitaitimakoto]: https://github.com/KitaitiMakoto
[github_user_lilibethdlc]: https://github.com/lilibethdlc
[github_user_shinjiikeda]: https://github.com/shinjiikeda
[ruby_bug_13111]: https://bugs.ruby-lang.org/issues/13111
[rubydoc]: http://rubydoc.info/gems/rambling-trie
