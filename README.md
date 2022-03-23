# hookah

An elegantly minimal solution for Git hooks

## Why?

I don't wish to use [husky](https://github.com/typicode/husky), [overcommit](https://github.com/sds/overcommit), and [pre-commit](https://github.com/pre-commit/pre-commit) for various reasons. None had exactly what I was looking for, so I built a simple solution

## Features

- _No configuration_
- Language agnostic (ex. not tied to npm's `postinstall`)
- Elegantly minimal

## Subcommands

- `refresh`
  - Installs Hookah to the local repo (a message will be printed if anything has been updated)
- `check`
  - Ensures all hook scripts will work _before_ running Git
- `new`
  - Shows a menu of all possible hooks. Selecting one creates a _minimal_ template in the correct location

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/hookah
```
