# 🐘 Postgres Workflow
_______________________________________________________________________________

## Setup

If you ever want to setup your workflow after cloning this directory,
or moving it to a different location, just run the three commands below:
```sh
mise trust
chmod +x .mise-tasks/*.bash
mise install
```
_______________________________________________________________________________

## Usage

Run this command to view your list of available `mise` tasks
```bash
mise tasks
```

You should see this
```
Name           Description
check-status   🚥 Check the status of Postgres | alias = check-status
setup-cluster  🐘 Setup the Postgres Cluster | alias = setup-cluster
```

You can run a command by using the syntax:
`mise run name-of-command` or just the alias `name-of-command`
_______________________________________________________________________________

Run this command to view a list of available commands:
```bash
menu
```

You should see this
```
Name            Description
backup-cluster  📸 Backup the Postgres Cluster | alias = backup-cluster
check-status    🚥 Check the status of Postgres | alias = check-status
connect-admin   📜 Connect as admin user with pqsl | alias = connect-admin
setup-cluster   🏡 Setup the Postgres Cluster | alias = setup-cluster
toggle-server   🐘 Toggle the Postgres Server | alias = toggle-server

alias          command
backup-cluster mise run backup-cluster
check-status   mise run check-status
connect-admin  mise run connect-admin
menu           mise tasks; echo; mise shell-alias ls
setup-cluster  mise run setup-cluster
toggle-server  mise run toggle-server
```
_______________________________________________________________________________
