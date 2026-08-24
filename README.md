# Homebrew tap for rastair

[rastair](https://github.com/bsbludwig/rastair) detects genetic variants and
methylated positions from TAPS+ or 5-base sequencing data.

## Install

```sh
brew install bsbludwig/rastair/rastair
```

## Migrating from the Bitbucket tap

Both this and the rastair repo moved from Bitbucket to GitHub.
If you installed rastair with `brew` before the move, remove the old tap first so Homebrew stops trying to reach Bitbucket:

```sh
brew uninstall rastair
brew untap bsblabludwig/rastair
brew install bsbludwig/rastair/rastair
```

## Building from source

`--HEAD` builds from the tip of `main` instead of using a release binary:

```sh
brew install --HEAD bsbludwig/rastair/rastair
```
