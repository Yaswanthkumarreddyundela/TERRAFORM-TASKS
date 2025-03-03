#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

setup_database() {
    echo "--------------------- Database Setup ---------------------------"
    
    # Install MySQL server
    install_package "mysql-server"
    
    # Configure MySQL
    MYSQL_CONFIG_FILE="/etc/mysql/my.cnf"
    
    # MySQL configuration for CloudStack
    MYSQL_CONFIG="
[mysqld]
server-id=1
innodb_rollback_on_timeout=1
innodb_lock_wait_timeout=600
max_connections=350
log-bin=mysql-bin
binlog-format = 'ROW'
"
    
    # Add configuration if not already present
    if ! grep -q "innodb_rollback_on_timeout=1" "$MYSQL_CONFIG_FILE"; then
        echo "$MYSQL_CONFIG" | tee -a "$MYSQL_CONFIG_FILE" > /dev/null
        validate $? "Configuring MySQL for CloudStack"
    else
        echo -e "MySQL configuration already present ... $Y SKIPPING $N"
    fi
    
    # Restart MySQL to apply changes
    systemctl restart mysql
    validate $? "Restarting MySQL service"
    
    echo "MySQL database configured for CloudStack"
}

# Execute main function
setup_database