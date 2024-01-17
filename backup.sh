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

# Function to send a message to Telegram
send_message() {
  curl -s -X POST https://api.telegram.org/bot$TG_API_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID --data-urlencode text="$1"
}

# Function to send a file to Telegram
send_file() {
  echo "Sending file $1"
  curl -X POST https://api.telegram.org/bot$TG_API_TOKEN/sendDocument -F chat_id=$TG_CHAT_ID -F document=@"$1"
}

# Function to send notification
send_notification() {
  if [ $backup_exit_status -eq 0 ]; then
    TOTAL_SIZE=$(echo "$export_output" | grep 'Total' | sed -n 's/.*[[:space:]]\([0-9.]*[[:space:]]MB\).*/\1/p')

    # Using a heredoc for the message
    send_message "$(cat <<EOF
✅ Backup réussie pour l'app de généalogie d'Hébrail.
🗂️ Taille totale: $TOTAL_SIZE
EOF
    )"
    send_file "${backup_file}.tar.gz"
  else
    send_message "❌ Backup foirée sur l'app de généalogie d'Hébrail, allez voir les logs cron."
  fi
}


# Call the function to send the notification
send_notification

# Delete old backups, keeping the last 30 versions
cd "${backup_dir}" || exit
ls -t "${export_file}"_* | tail -n +31 | xargs rm -f
