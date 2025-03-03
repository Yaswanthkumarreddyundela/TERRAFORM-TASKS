#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

configure_network() {
    echo "--------------------- Configure Network ---------------------------"
    
    # Detect network interface
    INTERFACE=$(ip addr | awk -F: '/^[0-9]+: (enp|ens|eth)/ {print $2; exit}' | xargs)
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    GATEWAY=$(ip r | grep "^default" | awk '{print $3}')
    
    # Determine netplan file path
    if [[ -e "/etc/netplan/00-installer-config.yaml" ]]; then
        FILE_PATH="/etc/netplan/00-installer-config.yaml"  # VMware
    else
        FILE_PATH="/etc/netplan/01-network-manager-all.yaml"  # VirtualBox or default
    fi
    
    # Create YAML configuration
    YAML_CONFIG=$(cat <<EOF
network:
   version: 2
   renderer: networkd
   ethernets:
     $INTERFACE:
       dhcp4: false
       dhcp6: false
       optional: true
   bridges:
     cloudbr0:
       addresses: [$IP_ADDRESS/24]
       routes:
        - to: default
          via: $GATEWAY
       nameservers:
         addresses: [1.1.1.1,8.8.8.8]
       interfaces: [$INTERFACE]
       dhcp4: false
       dhcp6: false
       parameters:
         stp: false
         forward-delay: 0
EOF
)
    
    # Create or clear the file
    if [[ -e $FILE_PATH ]]; then
        > $FILE_PATH
        validate $? "Clearing the file to configure network"
    else
        touch $FILE_PATH
        validate $? "Creating .yaml file for configuration"
    fi
    
    # Write configuration to file
    echo "$YAML_CONFIG" > $FILE_PATH 
    validate $? "Configuring the .yaml file"
    
    # Apply network configuration
    netplan apply &>> "$LOG_FILE_NAME"
    validate $? "Applying network configuration"
    
    # Apply with debug for logging
    netplan --debug apply &>> "$LOG_FILE_NAME"
    validate $? "Debug apply for network configuration"
    
    # Restart NetworkManager
    systemctl restart NetworkManager
    validate $? "Restarting network manager"
    
    echo "Network configuration complete. Bridge cloudbr0 has been set up."
}

# Execute main function
configure_network