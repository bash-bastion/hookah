# Hookah lib.sh

Hookah: An elegantly minimal solution for Git hooks

## Overview

Hookah streamlines the process of managing Git hooks. This file is a
library of functions that can easily be used by hooks written in Bash. Use it by
prepending your script with the following

```bash
#!/usr/bin/env bash

source "${0%/*}/.hookah/lib.sh"
hookah.init
```

Learn more about it [on GitHub](https://github.com/hyperupcall/hookah)

## Index

* [hookah.init()](#hookahinit)
* [hookah.run()](#hookahrun)
* [hookah.run_allow_fail()](#hookahrun_allow_fail)
* [hookah.is_ci()](#hookahis_ci)

### hookah.init()

Initiates the environment, sets up stacktrace printing on the 'ERR' trap,
and sets the directory to the root of the Git repository

_Function has no arguments._

### hookah.run()

Prints a command before running it
#args $@ Command to execute

### hookah.run_allow_fail()

Prints a command before running it. But, if the command fails, do not abort execution

#### Arguments

* # @args $@ Command to execute

### hookah.is_ci()

Scans environment variables to determine if script is in a CI environment

#### Variables set

* **REPLY** (Current): provider for CI

#### Exit codes

* **0**: If in CI
* **1**: If not in CI

