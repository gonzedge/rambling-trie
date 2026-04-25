# CLAUDE.md — rambling-trie

## Project overview

`rambling-trie` is a Ruby gem implementing a compressed trie data structure. The main entry point
is `Rambling::Trie` (`lib/rambling/trie.rb`). Node types live under `lib/rambling/trie/nodes/`.

## Commands

```sh
bundle exec rake spec        # run tests
bundle exec rake reek        # run reek smell detector
bundle exec rake rubocop     # run RuboCop linter
bundle exec rake steep       # run Steep type checker
bundle exec rake             # runs all of the above (spec + reek + rubocop + steep)
```

## Workflow

Each issue gets its own branch and PR. Use spec-first TDD:

1. Write failing spec(s), commit with `git add <files>`
2. Confirm failure with `bundle exec rspec <spec_file>`
3. Implement the fix, commit
4. Run the full suite: `bundle exec rake spec`
5. Run Rubocop: `bundle exec rake rubocop`
6. Run Steep: `bundle exec rake steep`
7. Run Reek: `bundle exec rake reek`
8. Prompt the user for PR number
9. Update CHANGELOG and both code review docs, commit

_**NOTE:** Never attempt to create a PR_.

## Git conventions

- Branch names: `gonzedge/<short-description>`
- Commit body (for issue-linked commits):
  `_Deals with issue no. N in [doc/20260418-claude-code-review.md](doc/20260418-claude-code-review.md)._`
- Doc files are gitignored; stage them with `git add -f doc/...` but prompt the user before staging a new one

_**NOTE:** Never attempt to do a `git push`_.

## PR descriptions (raw markdown, no formatting by Claude)

- Title: sentence case, no trailing period
- Problem context in **present tense** (not past)
- Use "deals with" (not "addresses") and no `#` before issue number
- Include "This PR:" section describing what the PR does
- No line-length restrictions
- No em-dashes (–)

## CHANGELOG format

File: `CHANGELOG.md`

```
## <version> (in development)

### Enhancements

#### Major
- ...

#### Minor
- ...
```

- No "Bug Fixes" section — all entries go under Enhancements (Major or Minor)
- New entries always appended at the **bottom** of their section
- Entry format: `- <PR title> ([#N][github_pull_N]) by [@gonzedge][github_user_gonzedge]`
- Add matching link definition: `[github_pull_N]: https://github.com/gonzedge/rambling-trie/pull/N` after all other PR
  links

## Code review docs

Two files track ongoing review work:
- `doc/20260418-claude-code-review.md` (primary, newer)
- `doc/20260411-claude-code-review.md` (earlier review; update when issues appear in both)

When an issue is fixed: mark `[x]` in the summary table and add `[#N][gh_N]` in the PR column.
When an issue is skipped: mark `[-]`, link to a `[feedback][fb_N]` section explaining why.
Link definition format: `[gh_N]: https://github.com/gonzedge/rambling-trie/pull/N`
Add both `gh_N` and `fb_N` link definitions at the bottom of the corresponding section within the links list.

_**NOTE:** Never use em-dashes (—)._

## Type signatures (RBS + Steep)

Every new module or class needs a corresponding `.rbs` file under `sig/lib/`.
After adding Ruby code, run `bundle exec steep check` and fix all errors before committing.

Key patterns:
- `module Foo : ::Object` — self-type constraint so `self.class`, `raise`, etc. resolve
- `-> bot` — return type for methods that always raise (subtype of everything)
- `private_constant` constants still need RBS declarations (with `# private` comment if needed)

## Reek suppressions

Inline suppressions go on the line **above** the class/module/method:

```ruby
# :reek:IrresponsibleModule
module Trie
```

For method-specific exclusions, prefer `.reek.yml` entries over inline comments.

## RBS + includes

When a module is included via unqualified name (e.g., `include NotImplemented`) because it is a
`private_constant`, add `include NotImplemented` to the including class's `.rbs` file as well.
