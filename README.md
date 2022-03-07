# hookah

An elegantly minimal solution for Git hooks

## Usage

```sh
cd some-git-repo-that-uses-hookah
hookah init
# And you're done!
```

- To update internal Hookah scripts, simply run `init` again (a message will be printed if anything has been updated)

## Features

- Has `check` subcommand to test if scripts will work _before_ running Git
- Has `create` subcommand to list all templates and how they work

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/hookah
```

## Roadmap

- Fix Stacktrace
