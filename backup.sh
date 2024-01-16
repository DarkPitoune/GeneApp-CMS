#!/bin/bash

# Set the backup directory and export file name
backup_dir="backup"
export_file="sauvegarde"
source .env
source ~/.nvm/nvm.sh

# Create a timestamp for the backup file
timestamp=$(date +"%Y%m%d%H%M%S")
backup_file="${backup_dir}/${export_file}_${timestamp}"

# Run the backup command and capture the exit status and output
nvm use 20
# create backup directory if it doesn't exist
mkdir -p "${backup_dir}"
export_output=$(yarn strapi export --file "${backup_file}" --no-encrypt)
backup_exit_status=$?

# Function to send email notification
send_notification() {
  if [ $backup_exit_status -eq 0 ]; then
    TOTAL_SIZE=$(echo "$export_output" | grep 'Total' | sed -n 's/.*[[:space:]]\([0-9.]*[[:space:]]MB\).*/\1/p')

    # Using a heredoc for the message
    cat <<EOF
✅ Backup réussie pour l'app de généalogie d'Hébrail.
🗂️ Taille totale: $TOTAL_SIZE
EOF
  else
    cat <<EOF
❌ Backup foirée sur l'app de généalogie d'Hébrail, allez voir les logs cron.
EOF
  fi | curl -s -X POST https://api.telegram.org/bot$TG_API_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID --data-urlencode text@-
}


# Call the function to send the notification
send_notification

# Delete old backups, keeping the last 30 versions
cd "${backup_dir}" || exit
ls -t "${export_file}"_* | tail -n +31 | xargs rm -f
