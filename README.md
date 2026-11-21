# PostgreSQL Point-in-Time Recovery (PITR)

A practice template for restoring PostgreSQL to a chosen timestamp from a base backup and archived WAL files.

**Safety:** Use an isolated test/recovery instance and copies of backups. Never overwrite the only production data directory. Verify the backup, WAL coverage, target timestamp, and rollback plan before proceeding.

## Files
- `docs/recovery_runbook.md` — recovery procedure
- `docs/recovery_checklist.pdf` — printable checklist
- `config/recovery.conf.example` — PostgreSQL 12+ settings example
- `scripts/verify_archive.sh` — read-only directory checks

For PostgreSQL 12+, settings belong in `postgresql.conf` or an included file and recovery is triggered by `recovery.signal`. PostgreSQL 11 and earlier use the legacy `recovery.conf` method. Check documentation for your exact server version.
