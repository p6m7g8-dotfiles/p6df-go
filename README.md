# P6's POSIX.2: p6df-go

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Functions

#### p6df-go

##### p6df-go/init.zsh

- `p6df::modules::go::deps()`
- `p6df::modules::go::home::symlink()`
- `p6df::modules::go::init(_module, dir)`
- `p6df::modules::go::langs()`
- `p6df::modules::go::vscodes()`
- `str str = p6df::modules::go::prompt::env()`
- `str str = p6df::modules::go::prompt::lang()`

#### p6df-go/lib

##### p6df-go/lib/env.sh

- `p6df::modules::go::goenv::latest()`
- `p6df::modules::go::goenv::latest::installed()`

##### p6df-go/lib/langs.sh

- `p6df::modules::go::langs::install()`
- `p6df::modules::go::langs::nuke()`
- `p6df::modules::go::langs::packages()`
- `p6df::modules::go::langs::pull()`

## Hierarchy

```text
.
├── init.zsh
├── lib
│   ├── env.sh
│   └── langs.sh
├── README.md
└── share

3 directories, 4 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
