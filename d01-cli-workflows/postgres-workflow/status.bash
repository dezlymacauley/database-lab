#!/usr/bin/env bash
#MISE description="Status check of the Postgres Dojo"
#MISE quiet=true

# Check if the Postgres cluster exists
echo
if [ -d ".postgres" ] && [ -f ".postgres/PG_VERSION" ]; then
    echo "🐘 A Postgres cluster was found"
else
    echo "⚫ No Postgres cluster was found"
fi

# Check if the Postgres server is running
if pg_ctl -D .postgres status 1>/dev/null 2>/dev/null; then
    echo
    echo "✅ The Postgres server is running"
    echo
else
    echo
    echo "⚫ There is no Postgres server currently running."
    echo
fi

# Check if pgcli is available
if command -v pgcli >/dev/null 2>&1; then
    echo "🐍 The pgcli command is available"
else
    echo "⚫ The pgcli command is not available"
fi

echo
