# hookah

STATUS: In development

An elegantly minimal solution for Git hooks

## Usage

```sh
cd some-git-repo-that-uses-hookah
hookah init
# Boom! You're done
```

## Features

- Simply run `init` again to update the Hookah scripts (a message will be printed if anything has been updated)
- Has `check` subcommand to test if scripts will work _before_ running Git
- Has `create` subcommand to list all templates and how they work
- _No configuration_
- Language agnostic (ex. not tied to npm's `postinstall`)

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/hookah
```
