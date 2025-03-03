#!/bin/bash

# Set up colors for output
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Configure logging
LOGS_FOLDER="/var/log"
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_PREFIX=$(basename "$0" .sh)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE_PREFIX-$TIMESTAMP.log"

# Validation function
validate() {
    if [ "$1" -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

# Root check function
check_root() {
    local USERID=$(id -u)
    if [ "$USERID" -ne 0 ]; then
        echo "ERROR :: you must have sudo access to execute this script"
        exit 1
    fi
}

# Function to install packages
install_package() {
    echo "Installing $1..."
    apt-get install -y "$1" &>> "$LOG_FILE_NAME"
    validate $? "Installing $1"
}

# Initialize log file
init_log() {
    echo "Script started executing at: $TIMESTAMP" &> "$LOG_FILE_NAME"
    check_root
}