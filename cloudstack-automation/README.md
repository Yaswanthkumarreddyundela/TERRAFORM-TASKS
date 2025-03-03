# CloudStack Automation

This repository contains a set of automation scripts to deploy Apache CloudStack 4.18 on Ubuntu or Enterprise Linux. These scripts provide a streamlined approach to setting up a complete CloudStack environment with KVM hypervisor.

## Overview

Apache CloudStack is an open-source Infrastructure-as-a-Service (IaaS) cloud orchestration platform that manages large networks of virtual machines. This automation repository helps you deploy a fully functional CloudStack environment with minimal manual intervention.

## Repository Structure

```
cloudstack-automation/
├── README.md                  # This file
├── 01-network-config.sh       # Network configuration with bridge setup
├── 02-hostname-setup.sh       # Hostname configuration 
├── 03-chrony-setup.sh         # NTP synchronization setup
├── 04-cloudstack-install.sh   # CloudStack package installation
├── 05-database-setup.sh       # MySQL database configuration
├── 06-cloudstack-init.sh      # CloudStack database initialization
├── 07-kvm-hypervisor.sh       # KVM hypervisor installation and configuration
├── 08-storage-config.sh       # NFS storage setup
├── 09-cloudstack-ui-guide.md  # Manual UI configuration guide
└── utils/
    └── common-functions.sh    # Shared utility functions
```

## Prerequisites

- Ubuntu 22.04 LTS or Enterprise Linux 8 (e.g., Rocky Linux 8.7)
- Minimum hardware requirements:
  - 2 CPU cores
  - 4GB RAM (8GB recommended)
  - 60GB disk space
- Network with internet access
- Root or sudo privileges

## Installation Steps

Follow these steps in sequence to deploy your CloudStack environment:

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/cloudstack-automation.git
cd cloudstack-automation
chmod +x *.sh utils/*.sh
```

### 2. Network Configuration

This script sets up the bridge interface (cloudbr0) that CloudStack will use:

```bash
sudo ./01-network-config.sh
```

### 3. Hostname Setup

Configures the server's hostname and updates /etc/hosts:

```bash
sudo ./02-hostname-setup.sh
```

### 4. Chrony Setup

Installs and configures Chrony for time synchronization:

```bash
sudo ./03-chrony-setup.sh
```

### 5. CloudStack Installation

Installs CloudStack management server and dependencies:

```bash
sudo ./04-cloudstack-install.sh
```

### 6. Database Setup

Installs and configures MySQL for CloudStack:

```bash
sudo ./05-database-setup.sh
```

### 7. CloudStack Initialization

Initializes the CloudStack database and sets up the management server:

```bash
sudo ./06-cloudstack-init.sh
```

You'll be prompted for a database password during this step.

### 8. KVM Hypervisor Installation

Installs and configures KVM hypervisor and CloudStack agent:

```bash
sudo ./07-kvm-hypervisor.sh
```

### 9. Storage Configuration

Sets up NFS storage for CloudStack primary and secondary storage:

```bash
sudo ./08-storage-config.sh
```

### 10. CloudStack UI Configuration

After completing the automated scripts, you'll need to perform the final steps manually through the CloudStack UI. Follow the instructions in `09-cloudstack-ui-guide.md`.

## Accessing CloudStack UI

Once the installation is complete, access the CloudStack UI at:

```
http://YOUR_SERVER_IP:8080/client
```

Default credentials:
- Username: admin
- Password: password

## CloudStack Zone Configuration

After script execution, you'll need to set up your CloudStack zone through the UI. This includes:

1. Creating a zone
2. Configuring public and private networks
3. Setting up a pod
4. Creating a cluster
5. Adding your host
6. Configuring primary and secondary storage

The `09-cloudstack-ui-guide.md` file provides detailed instructions for these steps.

## Troubleshooting

### Logs

All scripts generate logs in `/var/log/` with the format `scriptname-timestamp.log`. Check these logs for detailed information if you encounter issues.

### Common Issues

1. **Network Configuration**: If the bridge setup fails, verify your network interface name and try running the script again.

2. **Database Initialization**: If CloudStack database initialization fails, ensure MySQL is properly configured with the settings in `05-database-setup.sh`.

3. **KVM Modules**: If KVM modules aren't loaded, verify your hardware supports virtualization and it's enabled in BIOS.

## Notes

- These scripts are designed for a single-server deployment for testing/development purposes.
- For production deployments, refer to the official CloudStack documentation for recommended architectures.
- The CloudStack UI configuration must be done manually following the automated setup.

## References

- [Apache CloudStack Documentation](https://docs.cloudstack.apache.org/)
- [ShapeBlue IaaS Quick Build Guide](https://www.shapeblue.com/cloudstack-documentation/)

## License

This project is licensed under the Apache License 2.0.
