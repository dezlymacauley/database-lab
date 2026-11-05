# Postgres Workflow Setup Guide
_______________________________________________________________________________

Create a directory for the workflow, and enter it
```bash
mkdir postgres-workflow 
cd postgres-workflow
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
_.file = ".env"   
```
_______________________________________________________________________________

Use `mise` to add the latest version of Postgres to the project
```bash
mise use postgres@latest
```
_______________________________________________________________________________

Use `mise` to add the latest version of `pgcli` to the project
```bash
mise use "pipx:pgcli"@latest
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
_.file = ".env"   

[tools]
"github:quarylabs/sqruff" = "latest"
"pipx:pgcli" = "latest"
postgres = "latest"
```
_______________________________________________________________________________

Create the rest of the workflow structure
```bash
mkdir .mise-tasks
touch .mise-tasks/check-status.bash
touch .mise-tasks/setup-cluster.bash
chmod +x .mise-tasks/*.bash

touch .env
touch .env_example
touch .gitignore
touch .pgcli.ini
touch .sqruff.ini
```
_______________________________________________________________________________

Add this to the `.mise-tasks/check-status.bash` file
```bash
#!/usr/bin/env bash
#MISE description="🚥 Check the status of Postgres | alias = check-status"
#MISE quiet=true

# Check if the Postgres cluster exists
printf "\n"
if [ -f "$PGDATA/PG_VERSION" ]; then
    printf "✅  A Postgres cluster was found\n"
else
    printf "⚫ No Postgres cluster was found\n"
fi

# Check if the Postgres server is running
if pg_ctl status > /dev/null 2>&1; then
    printf "\n✅ The Postgres server is running\n\n"
else
    printf "\n⚫ There is no Postgres server currently running\n\n"
fi
```
_______________________________________________________________________________

Add this to the `.mise-tasks/setup-cluster.bash` file
```bash

```
_______________________________________________________________________________

Add this to the `.gitignore` file. 
```gitignore
# Environment Variables
.env*
!.env_example

# Postgres Cluster
.postgres/
```
_______________________________________________________________________________

Add this to the `.env_examples` file
```env
# vim: filetype=env
PGDATA=".postgres"
PGHOST="127.0.0.1"
PGPORT="5432"

PGUSER="postgres"
PGDATABASE="starter_database"

PGCLI_CONFIG_FILE = ".pgcli_config.ini"
POSTGRES_BACKUP_DIRECTORY="$HOME/local-workspace/postgres-database-backups"
```
_______________________________________________________________________________

Add this to the `.env` file to use the starter settings, 
or use your own custom values
```env
# vim: filetype=env
PGDATA=".postgres"
PGHOST="127.0.0.1"
PGPORT="5432"

PGUSER="postgres"
PGDATABASE="starter_database"

PGCLI_CONFIG_FILE = ".pgcli_config.ini"
POSTGRES_BACKUP_DIRECTORY="$HOME/local-workspace/postgres-database-backups"
```
_______________________________________________________________________________

Add this to the `.pgcli.ini` file
```ini
# vim: filetype=dosini
# This comment above lets Neovim know that this is a `dosini` file
# so that it can provide syntax highlighting
# _____________________________________________________________________________

[main]

# Hides the startup and exit message
less_chatty = True

# Show/hide the informational toolbar with function keymap at the footer.
show_bottom_toolbar = False 

# No history file
history_file = /dev/null

# Disable logs
log_level = "NONE"
log_file = /dev/null

prompt = "\x1b[1;38;5;134m\d\x1b[0m 🐘 \n"

# Changes the colour theme.
syntax_style = fruity

use_local_timezone = False

# Multi-line mode allows breaking up the sql statements into multiple lines. If
# this is set to True, then the end of the statements must have a semi-colon.
# If this is set to False then sql statements can't be split into multiple
# lines. End of line (return) is considered as the end of the statement.
multi_line = True 

# Destructive warning mode will alert you before executing a sql statement
# that may cause harm to the database such as "drop table", "drop database"
# or "shutdown".
destructive_warning = True
# _____________________________________________________________________________
```
_______________________________________________________________________________

Add this to the `.sqruff.ini` file
```ini
[sqruff]
dialect = postgres
rules = all

[sqruff:indentation]
indent_unit = space
tab_space_size = 4
indented_joins = True
```
_______________________________________________________________________________

Update the `mise.toml` file to look like this
```toml
[env]
_.file = ".env"

#______________________________________________________________________________

[tools]
"github:quarylabs/sqruff" = "latest"
"pipx:pgcli" = "latest"
postgres = "latest"
#______________________________________________________________________________

[shell_alias]
server-status = "mise run server-status"
setup-cluster = "mise run setup-cluster"
```
_______________________________________________________________________________





#______________________________________________________________________________

[tasks.connect]
description = "🪶 Connect to the SQLite database | alias = connect"
quiet = true
run = """
mkdir -p .sqlite-databases
litecli \
    --liteclirc "$LITECLI_CONFIG_FILE" \
    --database "$SQLITE_DATABASE_FILE"
"""
#______________________________________________________________________________

[tasks.backup]
description = "💾 Backup all SQLite databases | alias = backup"
quiet = true
run = """
mkdir -p "$SQLITE_BACKUP_DIRECTORY"

for db in .sqlite-databases/*.sqlite; do
  [ -e "$db" ] || continue

  base=$(basename "$db" .sqlite)
  ts=$(date -u +"%Y%m%dT%H%M%SZ")

  sqlite3 "$db" ".backup $SQLITE_BACKUP_DIRECTORY/${base}_${ts}.sqlite"
done
"""
#______________________________________________________________________________

[shell_alias]
connect = "mise run connect"
backup = "mise run backup"
#______________________________________________________________________________
```
_______________________________________________________________________________

Run this command to view your list of available `mise` tasks
```sh
mise tasks
```

You should see this
```
Name     Description
backup   💾 Backup all SQLite databases | alias = backup
connect  🪶 Connect to the SQLite database | alias = connect
```
_______________________________________________________________________________

If you ever want to setup your workflow after cloning this directory,
or moving it to a different location, just run the command below:
```sh
mise trust && mise install
```
_______________________________________________________________________________
