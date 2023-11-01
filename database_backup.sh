#!/bin/bash

# MySQL database credentials
DB_USER="your_db_user"
DB_PASS="your_db_password"
DB_NAME="your_db_name"

# Backup directory
BACKUP_DIR="/path/to/backup/directory"

# Date and time format for backup file names
DATE_TIME_FORMAT=$(date +"%Y%m%d_%H%M%S")

# Function to perform database backup
backup_database() {
    # Create a backup file name with date and time
    BACKUP_FILE="$BACKUP_DIR/db_backup_$DATE_TIME_FORMAT.sql"

    # Run mysqldump to create the backup
    mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILE

    # Check if the backup was successful
    if [ $? -eq 0 ]; then
        echo "Database backup completed: $BACKUP_FILE"
    else
        echo "Error: Database backup failed."
    fi
}

# Schedule the backup using cron
# Edit the cron schedule to set your preferred time and frequency
# Example: Run the backup every day at 2:00 AM
# Note: You need to use the 'crontab -e' command to edit the cron
