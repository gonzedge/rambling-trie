# Releasing Rambling Trie

## Prerequisites

- Push access to the `gonzedge/rambling-trie` GitHub repository
- Publish rights on [RubyGems][rubygems_rambling_trie]
- A clean, up-to-date `main` branch

## Steps

### 1. Verify the suite is green

```sh
bundle exec rake
```

All specs, RuboCop, Reek, and Steep checks must pass before proceeding.

### 2. Check out to a new branch

```sh
git checkout -b <bump-version-to-x-y-z>
```

### 3. Bump the version

Edit `lib/rambling/trie/version.rb`:

```ruby
VERSION = 'X.Y.Z'
```

Follow [Semantic Versioning][semver]:

- **Patch** (`X.Y.Z+1`): bug fixes, no API changes
- **Minor** (`X.Y+1.0`): new features or deprecations, backwards-compatible
- **Major** (`X+1.0.0`): breaking changes (removed or changed API)

### 4. Update CHANGELOG.md

- Remove `(in development)` from the current version heading
- Replace the `[compare][compare_vOLD_and_main]` link with `[compare][compare_vOLD_and_vNEW]`
- Add a new `## X.Y.Z+1 (in development) [compare][compare_vNEW_and_main]` section at the top
- Add both new compare link definitions at the bottom of the file:

```markdown
[compare_vOLD_and_vNEW]: https://github.com/gonzedge/rambling-trie/compare/vOLD...vNEW
[compare_vNEW_and_main]: https://github.com/gonzedge/rambling-trie/compare/vNEW...main
```

### 5. Update README.md

- Update the version number in the RBS/Steep compatibility paragraph
- Update the `badge_fury_badge` URL version parameter:

```markdown
[badge_fury_badge]: https://badge.fury.io/rb/rambling-trie.svg?version=X.Y.Z
```

### 6. Update Dockerfile.benchmark

Bump the version reference in `Dockerfile.benchmark`.

### 7. Commit

```sh
git add lib/rambling/trie/version.rb CHANGELOG.md README.md Dockerfile.benchmark
git commit -m "Bump version to 'X.Y.Z'"
```

### 8. Create a PR

- Create the PR with the bump changes, name it `Bump version to 'X.Y.Z'`
- When everything passes and is approved, merged to `main`

### 7. Release

Once merged, get back to a clean, up-to-date `main` branch:

```sh
git checkout main
git pull
```

Then manually execute release task:

```sh
bundle exec rake release
```

This will:

- Build the gem
- Create and push a `vX.Y.Z` git tag
- Push the gem to [RubyGems][rubygems]

[rubygems]: https://rubygems.org
[rubygems_rambling_trie]: https://rubygems.org/gems/rambling-trie
[semver]: https://semver.org
