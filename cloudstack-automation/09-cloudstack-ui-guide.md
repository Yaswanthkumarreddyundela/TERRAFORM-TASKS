# CloudStack UI Configuration Guide

This guide covers the manual steps needed to set up a CloudStack zone after the automated installation scripts have been executed.

## Accessing the CloudStack UI

1. Open a web browser and navigate to:
   ```
   http://YOUR_SERVER_IP:8080/client
   ```

2. Log in with the default credentials:
   - Username: `admin`
   - Password: `password`

## Setting Up a Zone

### 1. Create a Zone

1. In the CloudStack UI, go to **Infrastructure** > **Zone**
2. Click the **Add Zone** button
3. Select **Zone Type**: Choose "Advanced" for more networking options
4. Configure the following settings:
   - **Name**: Zone1 (or any name you prefer)
   - **IPv4 DNS 1**: 8.8.8.8 (Google DNS)
   - **Internal DNS 1**: 8.8.8.8
   - **Hypervisor**: KVM
5. Click **Next**

### 2. Configure Physical Network

1. On the Physical Network screen:
   - Leave the default name "Physical Network 1"
   - Isolation method: VLAN
   - Add all traffic types (Management, Guest, Public)
2. Click **Next**

### 3. Configure Public Traffic

1. Set the following details:
   - **Gateway**: Your network gateway (e.g., 192.168.1.1)
   - **Netmask**: 255.255.255.0
   - **VLAN/VNI**: Leave blank for your management network
   - **Start IP**: Choose a range (e.g., 192.168.1.20)
   - **End IP**: End of range (e.g., 192.168.1.50)
2. Click **Add**
3. Click **Next**

### 4. Configure Pod

1. Enter pod details:
   - **Name**: Pod1
   - **Reserved system gateway**: Your network gateway (e.g., 192.168.1.1)
   - **Reserved system netmask**: 255.255.255.0
   - **Start reserved system IP**: 192.168.1.51
   - **End reserved system IP**: 192.168.1.80
2. Click **Next**

### 5. Configure Guest Traffic

1. For guest traffic VLAN range:
   - **VLAN/VNI range**: 700-900
2. Click **Next**

### 6. Configure Cluster

1. For the cluster configuration:
   - **Name**: Cluster1
   - **Hypervisor**: KVM (should be pre-selected)
2. Click **Next**

### 7. Add Host

1. Add your KVM host:
   - **Hostname**: Your server's IP address
   - **Username**: root
   - **Password**: Your root password
2. Click **Next**

### 8. Configure Primary Storage

1. Set up primary storage:
   - **Name**: Primary1
   - **Scope**: Zone
   - **Protocol**: NFS
   - **Server**: Your server's IP address
   - **Path**: /export/primary
2. Click **Next**

### 9. Configure Secondary Storage

1. Set up secondary storage:
   - **Provider**: NFS
   - **Name**: Secondary1
   - **Server**: Your server's IP address
   - **Path**: /export/secondary
2. Click **Next**

### 10. Complete Zone Setup

1. Review all settings and click **Launch Zone** to finalize the configuration
2. Wait for CloudStack to complete the zone setup process
3. The system will automatically create and start the System VMs (SSVM, CPVM)

## Verify System VMs

1. Go to **Infrastructure** > **System VMs**
2. Check that the following system VMs are running:
   - Secondary Storage VM (SSVM)
   - Console Proxy VM (CPVM)

If both VMs show "Running" status, your CloudStack environment is operational.

## Add Templates

To deploy instances, you'll need to register templates:

1. Go to **Templates** > **Register Template**
2. Select appropriate OS template options
3. Provide template URL (CloudStack community templates are available online)
4. Complete the registration process

## Deploy Your First Instance

1. Go to **Compute** > **Instances**
2. Click **Add Instance**
3. Follow the wizard to deploy a virtual machine

## Network Offerings

CloudStack comes with default network offerings, but you can create custom ones:

1. Go to **Service Offerings** > **Network Offerings**
2. Click **Add Network Offering** to create customized network services

## Security

Remember to change the default admin password:

1. Click on your username in the top-right corner
2. Select **Change Password**
3. Enter a strong password and save changes

## Troubleshooting UI Issues

If you encounter issues with the CloudStack UI:

1. Check CloudStack management server logs:
   ```
   tail -f /var/log/cloudstack/management/management-server.log
   ```

2. Verify system VM logs:
   ```
   tail -f /var/log/cloudstack/management/system-vm.log
   ```

3. Check for errors in browser console (F12)

4. Ensure all required ports are open for communication between components

## Next Steps

After basic configuration, consider exploring:

- Setting up additional compute offerings
- Configuring networks with different isolation methods
- Implementing load balancing
- Setting up snapshots and backups
- Configuring user accounts and domains
- Implementing role-based access control
