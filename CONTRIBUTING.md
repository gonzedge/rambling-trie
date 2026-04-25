# Contributing to Rambling Trie

1. If you have found a bug or have a feature request, please [search through the issues][github_issues_all] to see if it
   has already been reported. If that's not the case, then [create a new one][github_issues_new] with a full description
   of what you have found or what you need.
2. If you have bug fix or a feature implementation in mind, then [fork Rambling Trie][github_fork] and create a branch
   with a descriptive name.
3. Get the gem up and running locally (tests are written in RSpec):

    ```sh
    bundle install
    bundle exec rake
    ```

4. Implement your bug fix or feature - ***make sure to add tests!***
5. [Make a Pull Request][github_pull_request]

    Before doing so:

    ```sh
    git remote add upstream git@github.com:gonzedge/rambling-trie.git
    git checkout main
    git pull upstream
    git checkout my-feature-branch
    git rebase main
    git push --set-upstream origin my-feature-branch
    ```

Feel free to reach out to [@gonzedge][github_user_gonzedge] with any questions.

## Running benchmarks

It's always a good idea to run benchmarks for any logic changes within `lib/`, to make sure your changes are not
adversely affecting performance. To run benchmarks you'll need to first have docker installed:

```sh
brew install --cask docker
```

Then, you just need to run:

```sh
./scripts/benchmark/run.sh -v <sha>
# or `./scripts/benchmark/run.sh -v <sha> -g` if your commit is already up on github
```

By default, benchmarks run against Ruby 3.3.6. Embed a Ruby version in the version string with `@` to override:

```sh
./scripts/benchmark/run.sh -v <sha>@3.4.0
```

Output is saved to `tmp/ruby-<ruby_version>-<sha>.benchmark`.

### Comparing two benchmarks

To compare performance, use `compare.sh`. It runs `run.sh` for each version and diffs the outputs.
Each version argument accepts an optional `@<ruby_version>` suffix:

```sh
# two trie versions, same ruby (defaults to 3.3.6)
./scripts/benchmark/compare.sh 2.6.0 2.6.1

# two git refs, same ruby
./scripts/benchmark/compare.sh -g <sha1> <sha2>

# two git refs, explicit ruby version for both
./scripts/benchmark/compare.sh -g <sha1>@3.4.0 <sha2>@3.4.0

# same trie version across two ruby versions (useful for catching stdlib regressions)
./scripts/benchmark/compare.sh 2.6.0@3.3.6 2.6.0@3.4.0
./scripts/benchmark/compare.sh -g <sha>@3.3.6 <sha>@3.4.0

# mix: different versions and different rubies
./scripts/benchmark/compare.sh -g <sha1>@3.3.6 <sha2>@3.4.0
```

[github_fork]: https://help.github.com/articles/fork-a-repo
[github_issues_all]: https://github.com/gonzedge/rambling-trie/issues?utf8=%E2%9C%93&q=is%3Aissue
[github_issues_new]: https://github.com/gonzedge/rambling-trie/issues/new
[github_pull_request]: https://help.github.com/articles/creating-a-pull-request
[github_user_gonzedge]: https://github.com/gonzedge
