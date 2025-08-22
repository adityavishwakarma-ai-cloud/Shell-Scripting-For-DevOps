#!/bin/bash
# ==============================================
# Project 1: User Management and Backup in Linux
# Author: Aditya Vishwakarma
# ==============================================

# Backup directory path
BACKUP_DIR="/backup"
LOG_FILE="/var/log/user_backup.log"

# Create backup & log directories if they don't exist
mkdir -p $BACKUP_DIR
touch $LOG_FILE

# Function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function: Add a new user
add_user() {
    read -p "Enter username to add: " username
    if id "$username" &>/dev/null; then
        echo "User $username already exists!"
        log_message "User $username already exists"
    else
        sudo useradd -m $username
        echo "User $username created successfully."
        log_message "User $username created"
    fi
}

# Function: Delete a user
delete_user() {
    read -p "Enter username to delete: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r $username
        echo "User $username deleted."
        log_message "User $username deleted"
    else
        echo "User $username does not exist!"
        log_message "Attempted to delete non-existing user $username"
    fi
}

# Function: Add a new group
add_group() {
    read -p "Enter group name to add: " groupname
    if getent group $groupname >/dev/null; then
        echo "Group $groupname already exists!"
        log_message "Group $groupname already exists"
    else
        sudo groupadd $groupname
        echo "Group $groupname created successfully."
        log_message "Group $groupname created"
    fi
}

# Function: Backup a directory
backup_directory() {
    read -p "Enter directory path to backup: " dir
    if [ -d "$dir" ]; then
        TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
        BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
        tar -czf $BACKUP_FILE $dir
        echo "Backup created at $BACKUP_FILE"
        log_message "Backup created for $dir -> $BACKUP_FILE"
    else
        echo "Directory $dir does not exist!"
        log_message "Failed backup: Directory $dir not found"
    fi
}

# Main Menu
while true; do
    echo "=================================="
    echo "   User Management & Backup Tool  "
    echo "=================================="
    echo "1. Add User"
    echo "2. Delete User"
    echo "3. Add Group"
    echo "4. Backup Directory"
    echo "5. Exit"
    echo "----------------------------------"
    read -p "Choose an option [1-5]: " choice

    case $choice in
        1) add_user ;;
        2) delete_user ;;
        3) add_group ;;
        4) backup_directory ;;
        5) echo "Exiting..."; log_message "Script exited"; exit 0 ;;
        *) echo "Invalid choice, try again." ;;
    esac
done
