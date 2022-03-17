# hookah

STATUS: BETA

An elegantly minimal solution for Git hooks

## Usage

```sh
cd some-git-repo
hookah refresh
```

## Features

- _No configuration_
- Language agnostic (ex. not tied to npm's `postinstall`)
- Use the `refresh` subcommand install Hookah to the local repo (a message will be printed if anything has been updated)
- Use the `check` subcommand to ensure all hook scripts will work _before_ running Git
- Use the `new` subcommand to show a menu of all possible hooks. Selecting one creates a _minimal_ template in the correct location

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/hookah
```
