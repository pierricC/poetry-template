# Getting started

This a template repository for anyone that want to set up
a new project within a virtualenv environment set up by poetry.

To get started, simply run:

```bash
./tasks/init.sh <envName>
```

This script does several things:
-  Install vscode extensions.
-  Install peotry if not installed.
-  Create the virtualenv environment based on the pyproject.toml and activate it.
-  Install pre-commit hooks and configure git.
