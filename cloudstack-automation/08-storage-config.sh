#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

configure_storage() {
    echo "--------------------- Configure NFS Storage ---------------------------"
    
    # Install NFS server
    install_package "nfs-kernel-server"
    
    # Create export directories
    mkdir -p /export/primary /export/secondary
    validate $? "Creating export directories"
    
    # Add exports if not already configured
    if ! grep -q "^/export/primary" /etc/exports; then
        echo "/export/primary *(rw,async,no_root_squash,no_subtree_check)" >> /etc/exports
        echo "/export/secondary *(rw,async,no_root_squash,no_subtree_check)" >> /etc/exports
        validate $? "Configuring NFS exports"
    else
        echo -e "NFS exports already configured ... $Y SKIPPING $N"
    fi
    
    # Apply exports
    exportfs -a
    validate $? "Applying NFS exports"
    
    # Configure NFS server
    sed -i -e 's/^RPCMOUNTDOPTS="--manage-gids"$/RPCMOUNTDOPTS="-p 892 --manage-gids"/g' /etc/default/nfs-kernel-server
    sed -i -e 's/^STATDOPTS=$/STATDOPTS="--port 662 --outgoing-port 2020"/g' /etc/default/nfs-common
    echo "NEED_STATD=yes" >> /etc/default/nfs-common
    sed -i -e 's/^RPCRQUOTADOPTS=$/RPCRQUOTADOPTS="-p 875"/g' /etc/default/quota
    
    # Restart NFS server
    systemctl restart nfs-kernel-server
    validate $? "Restarting NFS server"

}
configure_storage