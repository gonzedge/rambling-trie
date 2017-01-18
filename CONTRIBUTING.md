## Contributing to Rambling Trie

1. If you have found a bug or have a feature request, please [search through the issues][github_issues_all] to see if it has already been reported. If that's not the case, then [create a new one][github_issues_new] with a full description of what you have found or what you need.
1. If you have bug fix or a feature implementation in mind, then [fork Rambling Trie][github_fork] and create a branch with a descriptive name.
1. Get the gem up and running locally (tests are written in RSpec):

    ```sh
    bundle install
    rake
    ```

1. Implement your bug fix or feature - ***make sure to add tests!***
1. [Make a Pull Request][github_pull_request]

    Before doing so:

    ```sh
    git remote add upstream git@github.com:gonzedge/rambling-trie.git
    git checkout master
    git pull upstream
    git checkout my-feature-branch
    git rebase master
    git push --set-upstream origin my-feature-branch
    ```

Feel free to reach out to [@gonzedge][github_user_gonzedge] with any questions.

[github_fork]: https://help.github.com/articles/fork-a-repo
[github_issues_all]: https://github.com/gonzedge/rambling-trie/issues?utf8=%E2%9C%93&q=is%3Aissue
[github_issues_new]: https://github.com/gonzedge/rambling-trie/issues/new
[github_pull_request]: https://help.github.com/articles/creating-a-pull-request
[github_user_gonzedge]: https://github.com/gonzedge
