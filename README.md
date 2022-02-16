# hookah

A simple git-hooks solution

STATUS: IN DEVELOPMENT

Current solutions include [overcommit](https://github.com/sds/overcommit), [husky](https://github.com/typicode/husky), and [pre-commit](https://github.com/pre-commit/pre-commit)

Both overcommit and pre-commit are unecessarily complex

Husky is a step in the right direction, but there are things I don't like. The wrapper script sources a `~/.huskyrc` and everything is written in NodeJS unnecessarily

Hookah is a simple solution that makes it easy to ensure all developers of a particular project are using Git hooks
