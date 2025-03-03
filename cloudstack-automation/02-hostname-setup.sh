#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

configure_hostname() {
    echo "--------------------- Configure Hostname ---------------------------"
    
    # Get current hostname and IP
    HOSTNAME=$(hostname -f)
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    
    # Add entry to hosts file if not exists
    ENTRY="${IP_ADDRESS}        ${HOSTNAME}     cloud"
    HOSTS_FILE="/etc/hosts"
    
    if ! grep -q "$ENTRY" "$HOSTS_FILE"; then
        sed -i "3i$ENTRY" "$HOSTS_FILE"
        validate $? "Adding hostname entry to hosts file"
    else
        echo -e "Entry already exists ... $Y SKIPPING $N"
    fi
    
    # Set hostname
    hostnamectl set-hostname "$HOSTNAME" &>> "$LOG_FILE_NAME"
    validate $? "Setting Hostname"
    
    echo "Hostname configured as: $HOSTNAME"
}

# Execute main function
configure_hostname