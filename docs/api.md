# lib.sh

## Overview

Function library for Git hooks configured with Hookah

## Index

* [hookah.init()](#hookahinit)
* [hookah.run()](#hookahrun)
* [hookah.run_allow_fail()](#hookahrun_allow_fail)
* [hookah.is_ci()](#hookahis_ci)

### hookah.init()

initiates the environment, sets up stacktrace printing on 'ERR' trap,
and sets the directory to the root of the Git repository

_Function has no arguments._

### hookah.run()

Prints a command before running it

### hookah.run_allow_fail()

Prints a command before running it. If the command fails, print a message,
but do not abort execution

### hookah.is_ci()

Tests if currently in CI

#### Variables set

* **REPLY** (Current): provider for CI

#### Exit codes

* **0**: If in CI
* **1**: If not in CI

