#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

configure_chrony() {
    echo "--------------------- Configure Chrony ---------------------------"
    
    # Install chrony
    install_package "chrony"
    
    # Configure chrony (optional custom configuration)
    cat > /etc/chrony/chrony.conf << EOF
# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usable directives.

# Use public NTP servers
pool ntp.ubuntu.com        iburst maxsources 4
pool 0.ubuntu.pool.ntp.org iburst maxsources 1
pool 1.ubuntu.pool.ntp.org iburst maxsources 1
pool 2.ubuntu.pool.ntp.org iburst maxsources 2

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Enable hardware timestamping on all interfaces that support it.
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
#allow 192.168.0.0/16

# Serve time even if not synchronized to a time source.
#local stratum 10

# Specify directory for log files.
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking
EOF
    
    # Restart chrony
    systemctl restart chrony
    validate $? "Restarting chrony service"
    
    # Enable chrony at boot
    systemctl enable chrony
    validate $? "Enabling chrony service"
    
    echo "Chrony configured for NTP synchronization"
}

# Execute main function
configure_chrony