# Dev helper: run a quick row-count smoke check against the local TDOP database.
# The password is read from the PGPASSWORD environment variable - never hard-code
# secrets in this file (see TDOP-docs/SECURITY.md).
if (-not $env:PGPASSWORD) {
    throw "Set the PGPASSWORD environment variable first (e.g. `$env:PGPASSWORD = '<password>'), then re-run."
}
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
psql -U postgres -h localhost -d tdop -f (Join-Path $scriptDir "check_db.sql")
