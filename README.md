# b

A small Bash script that lists the branches you recently checked out, newest first, and lets you pick one with `fzf`. The list comes from `git reflog`, and the preview pane shows the git log of the highlighted branch.

Written in 2024; Nix packaging added in 2026.

## Requirements

- Git
- `fzf`. If it is missing and Homebrew is available, the script runs `brew install fzf`.

## Install and run

With Nix on Linux, run it directly:

```sh
nix run github:meros/bash-b
```

or install it, which also installs the `b(1)` man page:

```sh
nix profile install github:meros/bash-b
b
```

Without Nix, clone the repository and run the script inside a Git repository:

```sh
git clone https://github.com/meros/bash-b.git
bash-b/b.sh
```

## Status

Small and finished. Updates are limited to the Nix lock file.

## License

MIT. See `LICENSE`.
