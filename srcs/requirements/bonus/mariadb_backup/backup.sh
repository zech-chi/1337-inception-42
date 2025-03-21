#!/bin/sh

# BACKUP_DIR="/backup/$(date +%Y_%m_%d__%H_%M_%S__mariadb_backup)"

# mkdir -p "$BACKUP_DIR"

# mariabackup --backup \
#   --target-dir="$BACKUP_DIR" \
#   --user="$SQL_USER" \
#   --password="$SQL_PASSWORD" \
#   --host="mariadb" \
#   --port="3306"
#   --no-lock

# echo "Backup created at $BACKUP_DIR"


BACKUP_DIR="/backup/$(date +%Y_%m_%d__%H_%M_%S__mariadb_backup)"

mkdir -p "$BACKUP_DIR"

# Flush engine logs before backup
mysql -u"$SQL_USER" -p"$SQL_PASSWORD" -h "mariadb" -P 3306 -e "FLUSH ENGINE LOGS;"

# Optional: Enable read-only mode to minimize DB changes during backup
mysql -u"$SQL_USER" -p"$SQL_PASSWORD" -h "mariadb" -P 3306 -e "SET GLOBAL read_only = ON;"

# Run backup with --no-lock
mariabackup --backup \
  --target-dir="$BACKUP_DIR" \
  --user="$SQL_USER" \
  --password="$SQL_PASSWORD" \
  --host="mariadb" \
  --port="3306" \
  --no-lock

# Capture exit status
EXIT_STATUS=$?

# Disable read-only mode after backup
mysql -u"$SQL_USER" -p"$SQL_PASSWORD" -h "mariadb" -P 3306 -e "SET GLOBAL read_only = OFF;"

# Check if backup was successful
if [ $EXIT_STATUS -eq 0 ]; then
  echo "✅ Backup successfully created at $BACKUP_DIR"
else
  echo "❌ Backup failed!" >&2
  exit 1
fi