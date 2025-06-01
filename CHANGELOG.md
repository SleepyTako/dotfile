#  Changelog

All notable changes to my dotfiles will be listed here, starting at changes since version 0.0.0.
Unreleased
BREAKING CHANGES

    #1176 changed safe access (?.) behavior: Attempting to index in an empty JSON string ('""') is now an error.

## Fixes
Fix crash on invalid formattime format string (By: luca3s)
Fix crash on NaN or infinite graph value (By: luca3s)
Re-enable some scss features (By: w-lfchen)
Fix and refactor nix flake (By: w-lfchen)
