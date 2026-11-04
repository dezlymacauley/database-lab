# SQLite Workflow Setup Guide
_______________________________________________________________________________

Create a directory for the workflow
```bash
mkdir sqlite-workflow
```
_______________________________________________________________________________

Enter the directory
```bash
cd sqlite-workflow 
```
_______________________________________________________________________________

Create a `mise.toml` file and give `mise` permission to automatically
use it when you enter the directory.
```bash
touch mise.toml
mise trust
```
_______________________________________________________________________________

Add this to the `mise.toml` file
```toml
[env]
LITECLI_CONFIG_FILE = "litecli.ini"
SQLITE_DB_FILE = ".sqlite-databases/starter_database.sqlite"
```
_______________________________________________________________________________

Use `mise` to add the latest version of SQLite to the project
```bash
mise use sqlite@latest
```
_______________________________________________________________________________

Use `mise` to add the latest version of `litecli` to the project
```bash
mise use "pipx:litecli"@latest
```

- The prefix: `pipx` will actually use `uv` to download litecli from PyPI
_______________________________________________________________________________

Use `mise` to add the latest version of `sqruff` to the project
```bash
mise use "github:quarylabs/sqruff"@latest
```
- The prefix: `github:` will download the latest binary from the official
sqruff repository on GitHub 
_______________________________________________________________________________

Your `mise.toml` file should look like this now:
```toml
[env]
LITECLI_CONFIG_FILE = "litecli.ini"
SQLITE_DB_FILE = ".sqlite-databases/starter_database.sqlite"

[tools]
"github:quarylabs/sqruff" = "latest"
"pipx:litecli" = "latest"
sqlite = "latest"
```
_______________________________________________________________________________

Create the rest of the workflow structure
```bash
mkdir .sqlite-databases
sqlite3 :memory: ".save .sqlite-databases/starter_database.sqlite"

touch .gitignore
touch .litecli.ini
touch .sqruff.ini
```
_______________________________________________________________________________

Run this command to check that the SQLITE database is usable
```bash
sqlite3 .sqlite-databases/starter_database.sqlite \
  "PRAGMA integrity_check;"
```

You should see an output like this
```
╭─────────────────╮
│ integrity_check │
╞═════════════════╡
│ ok              │
╰─────────────────╯
```
_______________________________________________________________________________

Add this to the `.gitignore` file. 
```gitignore
# SQLite Database Files
.sqlite-databases/
```
_______________________________________________________________________________

Add this to the `.sqruff.ini` file
```toml
[sqruff]
dialect = sqlite
rules = all

[sqruff:indentation]
indent_unit = space
tab_space_size = 4
indented_joins = True
```
_______________________________________________________________________________



### TODO: Consider removing
mkdir .mise-tasks
touch .mise-tasks/sqlite-connect.bash
chmod u+x .mise-tasks/*bash
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
_______________________________________________________________________________

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
