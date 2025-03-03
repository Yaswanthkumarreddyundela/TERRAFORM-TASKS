#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

initialize_cloudstack() {
    echo "--------------------- Initialize CloudStack Database ---------------------------"
    
    # Prompt for database password
    read -s -p "Enter password for CloudStack database user: " DB_PASSWORD
    echo
    
    # Get server IP
    SERVER_IP=$(hostname -I | awk '{print $1}')
    
    # Initialize CloudStack database
    cloudstack-setup-databases cloud:"$DB_PASSWORD"@localhost --deploy-as=root -i "$SERVER_IP"
    validate $? "Initializing CloudStack database"
    
    # Set up CloudStack management server
    cloudstack-setup-management
    validate $? "Setting up CloudStack management server"
    
    echo "CloudStack database initialized and management server set up"
}

# Execute main function
initialize_cloudstack