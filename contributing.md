# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test rip2 https://github.com/jahands/asdf-rip2.git "rip --version"
```

Tests are automatically run in GitHub Actions on push and PR.
