#!/usr/bin/env bash
# /usr/local/bin/mysql_hourly_backup.sh

set -euo pipefail

BACKUP_DIR="/opt/mysql_backup"
DB="shopdb"
TIMESTAMP=$(date +"%F-%H%M")
BACKUP_FILE="${BACKUP_DIR}/${DB}-${TIMESTAMP}.sql.gz"
RETENTION_DAYS=2

mkdir -p "$BACKUP_DIR"
chown $(whoami) "$BACKUP_DIR" 2>/dev/null || true

mysqldump --single-transaction --quick --skip-lock-tables "$DB" | gzip -c > "$BACKUP_FILE"

find "$BACKUP_DIR" -maxdepth 1 -type f -name "${DB}-*.sql.gz" -mtime +$RETENTION_DAYS -delete

RSYNC_TARGET="kali@192.168.1.46:/opt/store/mysql/"
rsync -az --partial --delete --chmod=Du=rwx,Dg=rx,Do=rx,Fu=rw,Fg=r,Fo=r "$BACKUP_DIR/" "$RSYNC_TARGET"
