# PostgreSQL Point-in-Time Recovery Run-book

## Objective
Restore a database to a specific point in time using a valid base backup and the archived WAL files required to reach the target.

## Before starting
- Obtain approval and identify the recovery owner.
- Record the target timestamp and time zone.
- Confirm PostgreSQL major version and base-backup compatibility.
- Verify the base backup and that WAL archive coverage extends from the backup checkpoint through the requested target.
- Prefer a separate recovery host or disposable cluster. Preserve the original data directory and source backups.
- Confirm storage, ownership, permissions, encryption keys, and rollback plan.

## 1. Stop and prepare
1. Stop PostgreSQL on the isolated recovery instance using the host's service manager.
2. Confirm the instance is stopped before changing its data directory.
3. Preserve any existing data directory; do not delete the only copy.
4. Restore the selected base backup into a designated, empty recovery data directory using the method documented for that backup.

## 2. Configure recovery
For PostgreSQL 12+, adapt `config/recovery.conf.example` and add settings to `postgresql.conf` or an included file:
- `restore_command` retrieves WAL segments from the archive.
- `recovery_target_time` specifies the approved timestamp and time zone.
- `recovery_target_action` controls what happens at the target (for example, pause for inspection).
- Create an empty `recovery.signal` file in the restored data directory.
- Ensure the PostgreSQL service account can read the backup and WAL archive.

For PostgreSQL 11 and earlier, follow that version's documentation for the legacy `recovery.conf` method. Do not mix configuration methods.

## 3. Start and monitor
1. Start the isolated recovery instance.
2. Monitor PostgreSQL logs for WAL retrieval, replay progress, and errors.
3. Confirm recovery reaches the requested target and pauses/completes as configured.
4. If a WAL segment is missing or recovery errors occur, stop and investigate the archive chain. Do not skip required WAL files.

## 4. Verify the recovered point
1. Connect using an authorized database account.
2. Review server logs and recovery status using commands supported by the installed version.
3. Validate expected records and application-level consistency with the data owner.
4. Compare key tables, row counts, and known transactions around the target time.
5. Record the actual recovery point and any gap from the requested target.
6. Keep the instance isolated until validation and approval are complete.

Example read-only checks (adapt to your schema):
```sql
SELECT current_timestamp;
SELECT current_database();
SELECT count(*) FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');
```
These checks alone do not prove business correctness; perform application-specific validation.

## 5. Complete and document
Record the PostgreSQL version, base-backup identifier, WAL archive location, target timestamp, recovery times, and validation results. Obtain approval before redirecting applications or promoting the recovered instance. Preserve source backups and logs according to policy. Take a fresh backup after acceptance.

## Troubleshooting
- **WAL not found:** check archive path, permissions, completeness, and `restore_command` quoting.
- **Target not reached:** verify timestamp/time zone and WAL coverage.
- **Version mismatch:** use a compatible base backup and version-specific procedure.
- **Normal startup instead of recovery:** verify signal file and config location for PostgreSQL 12+.
- **Insufficient disk:** stop and provision space; do not delete source backups or WAL files.

## Completion criteria
The intended target is reached, logs have no unresolved recovery errors, application-level validation passes, and the authorized owner approves the result.
