#!/bin/bash
set -e

# Set the backup directory and export file name
backup_dir="backup"
export_file="sauvegarde"

# Create a timestamp for the backup file
timestamp=$(date +"%Y%m%d%H%M%S")
backup_file="${backup_dir}/${export_file}_${timestamp}"

# Run the backup command
yarn strapi export --file "${backup_file}" --no-encrypt

# Delete old backups, keeping the last 30 versions
cd "${backup_dir}" || exit
ls -t "${export_file}"_* | tail -n +31 | xargs rm -f
