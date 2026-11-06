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

Run this command to view list of shell-aliases:
```bash
mise shell-alias ls
```

You should see this
```
alias         command
check-status  mise run check-status
setup-cluster mise run setup-cluster
```
_______________________________________________________________________________
