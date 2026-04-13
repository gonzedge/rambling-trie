# Code Review: `rambling-trie` v2.6.0

Reviewed by Claude (claude-sonnet-4-6) on 2026-04-11.

---

## Summary Table

| Done | #  | Severity     | File                             | Issue                                                                                   |
|------|----|--------------|----------------------------------|-----------------------------------------------------------------------------------------|
| [x]  | 1  | **Critical** | `readers/plain_text.rb:15`       | `chomp!` yields `nil` → crash on files without trailing newline                         |
| [x]  | 2  | **Critical** | `compressor.rb:39,50`            | Falsy `value` silently dropped during compression                                       |
| [x]  | 3  | **Critical** | `enumerable.rb:10`               | Shared mutable `EMPTY_ENUMERATOR` Enumerator                                            |
| [x]  | 4  | **Critical** | `comparable.rb:11`               | `==` ignores the `value` attribute                                                      |
| [x]  | 5  | **Critical** | `serializers/zip.rb:33,59`       | Temp files never cleaned up — resource leak                                             |
| [ ]  | 6  | **High**     | `nodes/raw.rb:34`                | `add` mutates the caller's array                                                        |
| [x]  | 7  | **High**     | `container.rb:42`                | `concat` silently ignores `values` array length mismatch                                |
| [x]  | 8  | **High**     | `container.rb:186`               | `size` counts words, docs claim it counts letters                                       |
| [x]  | 9  | **High**     | `container.rbs:53`               | `words?` alias in RBS does not match Ruby's `words`                                     |
| [ ]  | 10 | **High**     | `nodes/compressed.rb:98`         | `children_match_prefix` silently truncates short prefix                                 |
| [ ]  | 11 | **High**     | `nodes/node.rb:42`               | Shared `children_tree` hash mutated via parent reassignment in `Compressed`             |
| [ ]  | 12 | **High**     | `serializers/marshal.rb`         | `Marshal.load` security risk with no runtime guard                                      |
| [ ]  | 13 | **Medium**   | `stringifyable.rb:22`            | `to_s` has O(depth²) string allocations                                                 |
| [ ]  | 14 | **Medium**   | `nodes/node.rb:59`               | `first_child` disables RuboCop to exploit loop-break trick                              |
| [ ]  | 15 | **Medium**   | `comparable.rb`, `enumerable.rb` | Module names shadow `::Comparable` and `::Enumerable`                                   |
| [ ]  | 16 | **Medium**   | `trie.rb:79`                     | `@properties` lazy init is not thread-safe                                              |
| [ ]  | 17 | **Medium**   | `container.rb:220`               | Unnecessary `.to_a` no-op and three intermediate allocations in `reversed_char_symbols` |
| [ ]  | 18 | **Medium**   | `nodes/node.rb:179`              | Abstract methods raise bare `NotImplementedError` with no context                       |
| [ ]  | 19 | **Medium**   | `provider_collection.rb:109`     | Dead `\|\| raise` and broken `default=` on empty collections                            |
| [ ]  | 20 | **Medium**   | `compressible.rb:10`             | Yoda condition `1 == children_tree.size`                                                |
| [ ]  | 21 | **Medium**   | `serializers/zip.rb:33`          | Indirect `File.basename` extraction path obscures intent                                |
| [ ]  | 22 | **Medium**   | `trie.rb:24,27`                  | Two `# noinspection` comments masking a type design problem                             |
| [ ]  | 23 | **Medium**   | `provider_collection.rb:73`      | `reset` can unexpectedly raise `ArgumentError`                                          |
| [ ]  | 24 | **Low**      | `container.rb:137`               | `inspect` traverses the entire tree — REPL/logging hazard on large tries                |
| [ ]  | 25 | **Low**      | `stringifyable.rb:11`            | `as_word` guard uses a double-negative condition                                        |
| [ ]  | 26 | **Low**      | `nodes/node.rb:35`               | `value` docstring copy-pasted from `parent` — wrong description                         |
| [ ]  | 27 | **Low**      | `container.rb:133`               | `each` returns a `Node`, not `self`, when a block is given                              |
| [ ]  | 28 | **Low**      | `configuration/properties.rb:42` | Hardcoded `/tmp` — not portable across platforms                                        |
| [ ]  | 29 | **Low**      | `serializers/yaml.rb:26`         | `aliases: true` enables billion-laughs YAML memory attack                               |
| [ ]  | 30 | **Low**      | `container.rb:61`                | `compress` returns `self` when already compressed — inconsistent identity               |

---

## Critical

### 1. `PlainText#each_word` yields `nil` on files without a trailing newline

**File:** `lib/rambling/trie/readers/plain_text.rb:15`

```ruby
::File.foreach(filepath) { |line| yield line.chomp! }
```

`String#chomp!` returns `nil` when there is nothing to remove. For the last line of any file that does not end with
`\n`, `chomp!` returns `nil`. That `nil` is yielded to the caller, which passes it to `container << nil`, which then
calls `nil.reverse` — a `NoMethodError`. Every dictionary file without a trailing newline crashes silently at the last
word.

**Fix:**

```ruby
::File.foreach(filepath) { |line| yield line.chomp }
```

---

### 2. `Compressor` silently drops falsy `value` attributes during compression

**File:** `lib/rambling/trie/compressor.rb:39` and `:50`

```ruby
value = other.value
compressed.value = value if value  # drops false, 0, "", [], etc.
```

Any node storing a falsy-but-non-nil value (`false`, `0`, `""`, `[]`) loses that value after compression. The `value`
attribute is typed as the generic `TValue` and is explicitly part of the public API. The same bug exists in both `merge`
and `compress_children_and_copy`.

**Fix:**

```ruby
compressed.value = value unless value.nil?
```

---

### 3. `EMPTY_ENUMERATOR` is shared mutable state

**File:** `lib/rambling/trie/enumerable.rb:10-11`

```ruby
EMPTY_ENUMERATOR = [].to_enum :each
```

An `Enumerator` carries internal cursor state (position). Two execution contexts calling `.next` on the same
`EMPTY_ENUMERATOR` concurrently interfere with each other. Even single-threaded, `rewind` from one call path shifts the
cursor seen by another. A constant Enumerator is inherently unsafe for concurrent use.

**Fix:** Replace with a method returning a fresh enumerator on each call:

```ruby
def empty_enumerator = [].each
```

---

### 4. `Comparable#==` ignores the `value` attribute

**File:** `lib/rambling/trie/comparable.rb:11-14`

```ruby
def == other
  letter == other.letter &&
    terminal? == other.terminal? &&
    children_tree == other.children_tree
end
```

`value` is never compared. Two nodes that differ only in their stored values compare as equal. `Container#==` delegates
entirely to this, so `trie1 == trie2` returns `true` even when the associated data differs throughout the trie.

**Fix:** Add `value == other.value &&` to the comparison.

---

### 5. Zip serializer never cleans up temp files — resource leak

**File:** `lib/rambling/trie/serializers/zip.rb:33` and `57-59`

In `load`, a file is extracted to a UUID-prefixed path in `tmp_path` and never deleted. In `dump`, an intermediate
serialized file is written to `tmp_path`, added to the zip, and never deleted afterward. Every call to `load` or `dump`
permanently grows the temp directory with no cleanup.

**Fix:** Wrap both operations in `ensure` blocks that delete the temp file:

```ruby
ensure
  ::File.delete(entry_path) if ::File.exist?(entry_path)
```

---

## High

### 6. `Raw#add` mutates the caller's array — destructive surprise

**File:** `lib/rambling/trie/nodes/raw.rb:33-34`

```ruby
def add_to_children_tree chars, value = nil
  letter = chars.pop || raise
```

`chars.pop` mutates the array passed by the caller. The docstring even acknowledges this: *"This method clears the
contents of the chars variable."* Callers who retain a reference to the original array silently see it emptied.
`Container` creates a fresh array each time and is not affected, but the public `Node#add` interface is dangerous for
any direct caller.

---

### 7. `Container#concat` silently ignores `values` array length mismatch

**File:** `lib/rambling/trie/container.rb:41-45`

```ruby
def concat words, values = nil
  if values
    words.each_with_index.map { |word, index| add(word, values[index]) }
```

When `words.size != values.size`, out-of-bounds indices return `nil` silently. Words get stored with `nil` values and no
error is raised. An `ArgumentError` check at the top of the method would surface this programming mistake immediately.

---

### 8. `Container#size` counts words but documentation claims it counts letters

**File:** `lib/rambling/trie/container.rb:184-188`

```ruby
# Size of the Root {Nodes::Node Node}'s children tree.
# @return [Integer] the number of letters in the root node.
def size
  root.size
end
```

`root.size` delegates to `Enumerable#size`, which is aliased to `count`, which performs a full traversal and counts
every word in the trie. The documentation says "the number of letters in the root node" — these are entirely different
things. The RBS signature also types the return as `Numeric` rather than `Integer`.

---

### 9. RBS alias `words?` does not match the Ruby alias `words`

**File:** `sig/lib/rambling/trie/container.rbs:53`

```rbs
alias words? scan   # ← wrong
```

The actual Ruby code at `container.rb:192`:

```ruby
alias_method :words, :scan   # no trailing ?
```

Steep infers a `words?` method that does not exist in Ruby and misses the actual `words` method. This is a
type-signature lie that silently breaks static analysis for any consumer of the `words` method.

---

### 10. `Compressed#children_match_prefix` silently truncates short prefixes

**File:** `lib/rambling/trie/nodes/compressed.rb:98`

```ruby
letter = (chars.shift(child_letter.size) || raise).join
return EMPTY_ENUMERATOR unless child_letter == letter
```

When `chars.size < child_letter.size`, `Array#shift(n)` takes only what is available without raising. The resulting
joined string is shorter than `child_letter`, the comparison fails, and `EMPTY_ENUMERATOR` is returned — silently
cutting off all `words_within` results for that branch. `partial_word_chars?` handles this case explicitly (lines 43-50)
but `children_match_prefix` does not.

---

### 11. Shared `children_tree` hash mutated via parent reassignment in `Compressed`

**File:** `lib/rambling/trie/nodes/node.rb:42`, `nodes/compressed.rb:13-17`

`Compressed#initialize` forwards the existing `children_tree` hash directly to `super`, then iterates it to reassign
parents. If the same hash object is ever shared between two nodes (as can happen when constructing compressed trees from
existing subtrees), parent reassignment in one node is visible in the other.

---

### 12. `Marshal.load` is a security risk with no runtime guard

**File:** `lib/rambling/trie/serializers/marshal.rb`

`Marshal.load` of untrusted input can execute arbitrary code via crafted Ruby objects in the serialized stream. The API
documentation has a warning note, but the `load` method itself does nothing at runtime to communicate or mitigate the
risk. At minimum, a runtime warning via `Kernel.warn` would make the hazard explicit on each load call.

---

## Medium

### 13. `Stringifyable#to_s` has O(depth²) string allocation complexity

**File:** `lib/rambling/trie/stringifyable.rb:21-23`

```ruby
def to_s
  parent.to_s + letter.to_s
end
```

Each level allocates a new string containing the full prefix up to that point. For a word of depth N, the total
characters allocated is 1+2+3+…+N = N(N+1)/2. This is called during every `each`/`scan`/`words_within` traversal. A
single upward traversal collecting letters into an array and joining once would reduce this to O(N).

---

### 14. `first_child` disables RuboCop to exploit a loop-break trick

**File:** `lib/rambling/trie/nodes/node.rb:58-64`

```ruby
# rubocop:disable Lint/UnreachableLoop
children_tree.each_value { |child| return child }
# rubocop:enable Lint/UnreachableLoop
nil
```

This deliberately triggers an "unreachable loop" violation to get the first hash value by immediately returning inside
the block. The `nil` on line 63 is also unreachable. The idiomatic replacement is a one-liner:

```ruby
def first_child = children_tree.each_value.first
```

---

### 15. Module names shadow `::Comparable` and `::Enumerable`

**File:** `lib/rambling/trie/comparable.rb`, `lib/rambling/trie/enumerable.rb`

`Rambling::Trie::Comparable` and `Rambling::Trie::Enumerable` shadow the standard library modules of the same name. In
any scope where the `Rambling::Trie` namespace is open, bare references to `Comparable` or `Enumerable` resolve to the
gem's modules instead of stdlib. The gem correctly uses `::Enumerable` internally, but this is a constant-resolution
footgun for contributors and anyone extending or including the gem's namespaces.

---

### 16. `@properties` lazy initialization is not thread-safe

**File:** `lib/rambling/trie.rb:79`

```ruby
def properties
  @properties ||= Rambling::Trie::Configuration::Properties.new
end
```

Two threads calling `Rambling::Trie.config` simultaneously can each observe `@properties` as `nil`, both instantiate
`Properties`, and the second write silently discards the first's initialization and any configuration applied to it. A
`Mutex`-guarded init is the standard fix.

---

### 17. Unnecessary allocations and no-op in `reversed_char_symbols`

**File:** `lib/rambling/trie/container.rb:219-221`

```ruby
def reversed_char_symbols word
  word.reverse.chars.map(&:to_sym).to_a
end
```

- `word.reverse` allocates a new `String`
- `.chars` allocates an `Array`
- `.map(&:to_sym)` allocates another `Array`
- `.to_a` on an `Array` is a no-op

Using `map!` instead of `map` eliminates one allocation. More importantly, every distinct character in every inserted
word becomes an interned `Symbol`. For multi-language or large dictionaries this grows symbol memory unboundedly until
GC collects dynamic symbols.

---

### 18. Abstract methods raise bare `NotImplementedError` with no context

**File:** `lib/rambling/trie/nodes/node.rb:179-193`

```ruby
def children_match_prefix chars
  raise NotImplementedError
end
```

When a subclass omits an implementation, the error message is empty. The developer must dig through the backtrace to
identify which class and method is missing. The idiomatic form is:

```ruby
def children_match_prefix _chars
  raise NotImplementedError, "#{self.class}##{__method__} is not implemented"
end
```

---

### 19. Dead `|| raise` and broken `default=` on empty collections in `ProviderCollection`

**File:** `lib/rambling/trie/configuration/provider_collection.rb:109-113`

```ruby
def contains? provider
  return true if provider.nil?
  providers.any? && provider_instances.include?(provider || raise)
end
```

- `provider || raise` is unreachable: `nil` already returned `true` on the previous line.
- If `providers` is empty, `providers.any?` short-circuits to `false`, making it impossible to `default=` any provider
  on an empty collection — even immediately after construction. This means `add` then `default=` fails unless `reset`
  has run first.

---

### 20. Yoda condition in `Compressible#compressible?`

**File:** `lib/rambling/trie/compressible.rb:10`

```ruby
1 == children_tree.size
```

Yoda conditions (`literal == variable`) are a C-era guard against accidental assignment (`=` vs `==`). Ruby's assignment
operator cannot appear in a conditional context the same way, so there is no defensive value here. The idiomatic form is
`children_tree.size == 1`.

---

### 21. Indirect `File.basename` extraction path in `Zip#load` obscures intent

**File:** `lib/rambling/trie/serializers/zip.rb:33`

```ruby
entry_path = path entry_name                      # /tmp/<uuid>-filename
entry.extract ::File.basename(entry_path),        # "<uuid>-filename"
             destination_directory: tmp_path
```

`File.basename` strips the directory, and `destination_directory:` adds it back, reconstructing the same full path as
`entry_path`. Passing `entry_path` directly (the older rubyzip API) expresses the intent without the detour and is less
brittle if `tmp_path` ever diverges from `File.dirname(entry_path)`.

---

### 22. `# noinspection` comments masking a type design problem

**File:** `lib/rambling/trie.rb:24,27`

```ruby
# noinspection RubyMismatchedArgumentType
if filepath
  reader ||= readers.resolve filepath
  # noinspection RubyMismatchedArgumentType
  (reader || raise).each_word(filepath) { |word| container << word }
```

Two IDE suppression comments in three lines signal a type design issue. The intermediate `reader ||= ...` assignment
with a separate `|| raise` guard is harder to follow than a single expression that fails loudly and immediately:

```ruby
reader = readers.resolve(filepath) || raise(ArgumentError, "no reader for #{filepath}")
reader.each_word(filepath) { |word| container << word }
```

---

### 23. `ProviderCollection#reset` can unexpectedly raise `ArgumentError`

**File:** `lib/rambling/trie/configuration/provider_collection.rb:71-75`

```ruby
def reset
  providers.clear
  configured_providers.each { |extension, provider| self[extension] = provider }
  self.default = configured_default
end
```

`self.default=` validates that `configured_default` is present in `providers`. If `configured_default` was set to a
custom object that was later replaced or is not in the freshly-rebuilt `providers`, `reset` raises `ArgumentError` with
no documentation warning. Using `@default = configured_default` directly (bypassing the setter's validation) is correct
here since `configured_default` was validated at initialization time.

---

## Low

### 24. `Container#inspect` traverses the entire tree — hazard for large tries

**File:** `lib/rambling/trie/container.rb:136-138`

```ruby
def inspect
  "#<#{self.class.name} root: #{root.inspect}>"
```

`root.inspect` recursively builds the full tree representation. For a production dictionary trie (hundreds of thousands
of nodes), calling `inspect` in a REPL, error message, or log line can freeze the process. A summary form would be
safer:

```ruby
def inspect
  "#<#{self.class.name} compressed: #{compressed?}, size: #{size}>"
end
```

---

### 25. `as_word` guard uses a double-negative condition

**File:** `lib/rambling/trie/stringifyable.rb:11`

```ruby
if letter && !terminal?
  raise Rambling::Trie::InvalidOperation, 'Cannot represent branch as a word'
end
to_s
```

The condition means *"has a letter AND is not terminal"*, but `!terminal?` forces a double-negative parse. A guard
clause form is both idiomatic and easier to read:

```ruby
raise InvalidOperation, 'Cannot represent branch as a word' if letter && !terminal?
to_s
```

---

### 26. `value` docstring copy-pasted from `parent` — wrong description

**File:** `lib/rambling/trie/nodes/node.rb:34-36`

```ruby
# Arbitrary value stored in this node
# @return [TValue, nil] the parent of the current node.
attr_accessor :value
```

The `@return` description says *"the parent of the current node"*, which was copy-pasted from the `parent` attribute
above it. Should read *"the value stored in this node"*.

---

### 27. `Container#each` returns a `Node`, not `self`, when a block is given

**File:** `lib/rambling/trie/container.rb:129-133`

```ruby
def each
  return enum_for :each unless block_given?
  root.each { |word| yield word }
end
```

When a block is given, the last expression is `root.each { ... }`, which returns the `root` node — not the `Container`.
The `Enumerable` contract and Ruby convention expect `each` to return the receiver (`self`). The implicit return should
be made explicit: add `self` as the final expression.

---

### 28. Hardcoded `/tmp` is not portable

**File:** `lib/rambling/trie/configuration/properties.rb:42`

```ruby
@tmp_path = '/tmp'
```

`/tmp` does not exist on Windows and may be non-writable or unexpectedly small in some containerized environments. The
stdlib `Dir.tmpdir` is the portable, cross-platform replacement:

```ruby
require 'tmpdir'
@tmp_path = Dir.tmpdir
```

---

### 29. `aliases: true` in YAML deserialization enables a billion-laughs memory attack

**File:** `lib/rambling/trie/serializers/yaml.rb:26`

```ruby
::YAML.safe_load(
  ...,
  aliases: true,
)
```

YAML aliases are used to represent shared references in the serialized trie, so disabling them would break
deserialization. However, a crafted YAML file using nested aliases can cause exponential memory expansion (
billion-laughs attack). This risk should be documented explicitly, and a depth or size limit should be considered for
any context where the input may not be fully trusted.

---

### 30. `Container#compress` returns `self` when already compressed — inconsistent identity

**File:** `lib/rambling/trie/container.rb:61-65`

```ruby
def compress
  return self if root.compressed?
  Rambling::Trie::Container.new compress_root, compressor
end
```

`compress` returns the same `Container` object when already compressed, but a brand-new `Container` when it performs
compression. Callers cannot use object identity (`equal?`) to detect whether compression occurred. For a
pure/non-mutating API, `compress` should always return a new container (wrapping the same already-compressed root when
no work is needed). `compress!` is the correct mutation path.
