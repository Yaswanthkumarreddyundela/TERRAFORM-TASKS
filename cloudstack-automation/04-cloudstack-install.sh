#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

install_cloudstack() {
    echo "--------------------- Install CloudStack Management Server ---------------------------"
    
    # Install dependencies
    install_package "bridge-utils"
    install_package "ntp"
    install_package "openjdk-11-jdk"
    
    # Add CloudStack repository
    echo "deb https://download.cloudstack.org/ubuntu jammy 4.18" | tee -a "/etc/apt/sources.list.d/cloudstack.list"
    validate $? "Adding CloudStack repository"
    
    # Import GPG key
    wget -O - https://download.cloudstack.org/release.asc | tee /etc/apt/trusted.gpg.d/cloudstack.asc
    validate $? "Importing CloudStack GPG key"
    
    # Update package lists
    apt-get update &>> "$LOG_FILE_NAME"
    validate $? "Updating package lists"
    
    # Install CloudStack packages
    install_package "cloudstack-management"
    install_package "cloudstack-usage"
    
    echo "CloudStack packages installed successfully"
}

# Execute main function
install_cloudstack