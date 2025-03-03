#!/bin/bash

# Source common functions
source utils/common-functions.sh

# Initialize log
init_log

install_kvm() {
    echo "--------------------- Install KVM Hypervisor ---------------------------"
    
    # Install KVM and CloudStack agent
    install_package "qemu-kvm"
    install_package "cloudstack-agent"
    
    # Enable VNC for console proxy
    sed -i -e 's/\#vnc_listen.*$/vnc_listen = "0.0.0.0"/g' /etc/libvirt/qemu.conf
    validate $? "Configuring VNC for console proxy"
    
    # Configure libvirt
    echo 'listen_tls=0' >> /etc/libvirt/libvirtd.conf
    echo 'listen_tcp=1' >> /etc/libvirt/libvirtd.conf
    echo 'tcp_port = "16509"' >> /etc/libvirt/libvirtd.conf
    echo 'mdns_adv = 0' >> /etc/libvirt/libvirtd.conf
    echo 'auth_tcp = "none"' >> /etc/libvirt/libvirtd.conf
    validate $? "Configuring libvirt"
    
    # Restart libvirt to apply changes
    systemctl restart libvirtd
    validate $? "Restarting libvirtd service"
    
    # Disable AppArmor for libvirtd (Ubuntu specific)
    if [ -d "/etc/apparmor.d" ]; then
        ln -sf /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/
        ln -sf /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper /etc/apparmor.d/disable/
        apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd
        apparmor_parser -R /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper
        validate $? "Disabling AppArmor for libvirtd"
    fi
    
    # Verify KVM is running
    if lsmod | grep -q kvm; then
        echo -e "KVM modules loaded ... $G SUCCESS $N"
    else
        echo -e "KVM modules not loaded ... $R FAILURE $N"
        exit 1
    fi
    
    echo "KVM hypervisor and CloudStack agent installed successfully"
}

# Execute main function
install_kvm