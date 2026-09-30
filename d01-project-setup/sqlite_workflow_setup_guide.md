# SQLite Workflow Setup Guide
_______________________________________________________________________________

Create a directory for the workflow
```bash
mkdir sqlite-workflow
```
_______________________________________________________________________________

Enter the directory
```bash
cd mise-sqlite-workflow 
```
_______________________________________________________________________________

Use `mise` to add the latest version of SQLite to the project
```bash
mise use sqlite@latest
```
_______________________________________________________________________________

Use `mise` to add the latest version of `litecli` to the project
```bash
mise use pipx:litecli@latest
```

- The prefix: `pipx` will actually use `uv` to download litecli from PyPI
_______________________________________________________________________________

Use `mise` to add the latest version of `litecli` to the project
```bash
mise use github:quarylabs/sqruff@latest
```
- The prefix: `github:` will download the latest binary from the official
sqruff repository on GitHub 
_______________________________________________________________________________

You should now have a `mise.toml` file that looks like this:

```toml
[tools]
sqlite = "latest"
"github:quarylabs/sqruff" = "latest"
"pipx:litecli" = "latest"
```
_______________________________________________________________________________

Create the following files and directories
```bash
mkdir .mise-tasks
touch .mise-tasks/sqlite-connect.bash
chmod u+x .mise-tasks/*bash

mkdir .sqlite-databases
touch .gitignore
touch .litecli.ini
touch .sqruff
```
_______________________________________________________________________________

Add this to the `.gitignore` file. 
```gitignore
# The SQLite database files
.sqlite-databases/
```
_______________________________________________________________________________

Add this to the `.mise-tasks/sqlite-connect.bash` file
```bash

```
_______________________________________________________________________________

Use uv to set a specific version of Python for your project:
```sh
uv init --bare -p 3.14.6
```

The `--bare` flag will create a minimal Python project setup that only
has a `pyproject.toml` file.

The `-p` flag just means Python version,
and it is followed by a specific version number of Python that you want
your project to use.
_______________________________________________________________________________

This will create a `pyproject.toml` file that looks like this

```toml
[project]
name = "python-project"
version = "0.1.0"
requires-python = ">=3.14.6"
dependencies = []
```
_______________________________________________________________________________

Create a .python-version file:

```sh
touch .python-version
```
_______________________________________________________________________________

Add the same Python version number to the file:
```sh
echo 3.14.6 > .python-version
```

This will be used by `uv` to keep track of what version of Python will be
used in the Python virtual environment.
_______________________________________________________________________________

Use `uv` to create a Python virtual environment.
```sh
uv venv
```

This will create a `.venv` directory in your project.

When you add dependencies to your project
This is where `uv` will install those dependencies to the `.venv` directory.

_______________________________________________________________________________

The last step to this:

```sh
uv sync
```
_______________________________________________________________________________

Then exit the project directory

```sh
cd ..
```
_______________________________________________________________________________

And re-enter the project directory

```sh
cd python-project
```
_______________________________________________________________________________

Now run this command to confirm that your project is using the Python from
your virtual enviroment.

```sh
which python
```

If you see this at the end of your path,
then that means that your project is using the virtual enviroment 
that was set by uv.

```
.venv/bin/python
```
_______________________________________________________________________________

Use `uv` to add litcli to the workflow

```sh
uv add --dev litecli
```

litcli is CLI SQLite client that is written in Python.

This is what you'll use to interact with a SQLite database.

Unlike the default SQLite client, litecli has syntax highlighting,
tab autocompletion and other quality of life features.
_______________________________________________________________________________

Use `uv` to add sqruff to the workflow

```sh
uv add --dev sqruff
```

sqruff is a Rust-powered formatter and language server for SQL files.

It supports many different SQL dialects.
_______________________________________________________________________________

You `pyproject.toml` should look like this now

```toml
[project]
name = "mise-sqlite-dev-workflow"
version = "0.1.0"
requires-python = ">=3.14.6"
dependencies = []

[dependency-groups]
dev = [
    "litecli>=1.17.1",
    "sqruff>=0.38.0",
]
```
_______________________________________________________________________________

Create a directory for your SQLite databases

```sh
mkdir .sqlite-databases
```
_______________________________________________________________________________

Create a config file for `sqruff`

```sh
touch .sqruff
```
_______________________________________________________________________________

Add this to the `.sqruff` file

```
[sqruff]
dialect = sqlite
rules = all

[sqruff:indentation]
indent_unit = space
tab_space_size = 4
indented_joins = True
```
_______________________________________________________________________________

Create a `litecli` configuration file

```sh
touch .litecli.ini
```
_______________________________________________________________________________

Add this to the `litecli` configuration file

```ini
[main]

# Hides the startup and exit message
less_chatty = True

# Show/hide the informational toolbar with function keymap at the footer.
show_bottom_toolbar = False 

# No history file
# history_file = /dev/null

prompt = "\x1b[1;38;5;134m\d\x1b[0m 🪶 \n"

# Changes the colour theme.
# I find this theme more readable since my terminal has a darak background.
syntax_style = fruity

use_local_timezone = False

# Multi-line mode allows breaking up the sql statements into multiple lines. If
# this is set to True, then the end of the statements must have a semi-colon.
# If this is set to False then sql statements can't be split into multiple
# lines. End of line (return) is considered as the end of the statement.
multi_line = True
```
_______________________________________________________________________________

Add this to the end your `mise.toml` file

```toml
[env]
LITECLI_CONFIG = ".litecli.ini"
SQLITE_DB = ".sqlite-databases/mise_sqlite_dev_workflow.sqlite"

[tasks.connect]
description = "🪶 Connect to SQLite using litecli"
quiet = true
run = """
mkdir -p .sqlite-databases
litecli \
--liteclirc "$LITECLI_CONFIG" \
--database "$SQLITE_DB"
"""

[tasks.setup]
description = "🚀 Setup the SQLite workflow"
quiet = true
run = """
mkdir -p .sqlite-databases
rm -rf .venv
uv sync
"""

[tasks.backup]
description = "💾 Backup all SQLite databases"
quiet = true
run = """
BACKUP_DIR="$HOME/sqlite-backups"
mkdir -p "$BACKUP_DIR"

for db in .sqlite-databases/*.sqlite; do
  [ -e "$db" ] || continue

  base=$(basename "$db" .sqlite)
  ts=$(date -u +"%Y%m%dT%H%M%SZ")

  sqlite3 "$db" ".backup $BACKUP_DIR/${base}_${ts}.sqlite"
done
"""
```
_______________________________________________________________________________

Run this command to view your list of available `mise` tasks,
you should see this:
```sh
mise tasks
```
_______________________________________________________________________________

You should you see this

```
Name     Description
backup   💾 Backup all SQLite databases
clean    🧼 Remove the .venv directory
connect  🪶 Connect to SQLite using litecli
setup    🚀 Setup the SQLite workflow
```
_______________________________________________________________________________

If you ever want to setup your workflow after cloning this directory,
or moving it to a different location, just run these three commands below:

```sh
mise trust
mise install
mise setup
```

This will do the following:
1. Give mise permission to read and execute the `mise.toml` file
2. Ensure that all `mise tools` are installed (sqlite and uv)
3. Ensure tha `litecli` and `sqruff` have been installed with `uv`

_______________________________________________________________________________
