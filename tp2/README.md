# TP 2 : Vm2 has join the server.

## Partie 1 : A la découverte de Az

Après Docker, il est temps d'automatisé l'instalation de création des VM sur Azure.

Mais avant ça, créons une vm d'abord.

### Création de la VM avec AZ

```cmd
az vm create --name VM2 --location westeurope --resource-group TP2 --image Ubuntu2204 --size Standard_B1s --ssh-key-values "C:\Users\yanis\.ssh\admin01AzureTP2VM1.pub" --admin-username admin01
```

Dans cette commande je suis obligé de créer un compte admin avec son mot de passe

Ma vm se crée (pause café du coup) et en revenant :

```bash
ssh -i .\.ssh\admin01AzureTP2VM1 admin01@20.73.81.170
The authenticity of host '20.73.81.170 (20.73.81.170)' can't be established.
ED25519 key fingerprint is SHA256:IigL5iCYUSbni4Vu/TlOykFz8csHkd14E4eNTnvDugo.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '20.73.81.170' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1021-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Apr  1 09:19:02 UTC 2025

  System load:  0.12              Processes:             114
  Usage of /:   5.2% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

admin01@VM2:~$
```

### Vérification du status de certain services :

- `walinuxagent`

```bash
$ systemctl status walinuxagent
● walinuxagent.service - Azure Linux Agent
     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2025-04-01 09:15:05 UTC; 11min ago
   Main PID: 730 (python3)
      Tasks: 6 (limit: 1004)
     Memory: 41.8M
        CPU: 2.592s
     CGroup: /system.slice/walinuxagent.service
             ├─ 730 /usr/bin/python3 -u /usr/sbin/waagent -daemon
             └─1429 python3 -u bin/WALinuxAgent-2.12.0.2-py3.9.egg -run-exthandlers

Apr 01 09:15:19 VM2 python3[1429]:     pkts      bytes target     prot opt in     out     source               destination
Apr 01 09:15:19 VM2 python3[1429]:        0        0 ACCEPT     tcp  --  *      *       0.0.0.0/0            168.63.129.16        tcp dpt:53
Apr 01 09:15:19 VM2 python3[1429]:       91    12396 ACCEPT     tcp  --  *      *       0.0.0.0/0            168.63.129.16        owner UID match 0
Apr 01 09:15:19 VM2 python3[1429]:        0        0 DROP       tcp  --  *      *       0.0.0.0/0            168.63.129.16        ctstate INVALID,NEW
Apr 01 09:15:19 VM2 python3[1429]: 2025-04-01T09:15:19.668109Z INFO ExtHandler ExtHandler
Apr 01 09:15:19 VM2 python3[1429]: 2025-04-01T09:15:19.668204Z INFO ExtHandler ExtHandler ProcessExtensionsGoalState started [incarnation_1 channel: WireSe>
Apr 01 09:15:19 VM2 python3[1429]: 2025-04-01T09:15:19.669927Z INFO ExtHandler ExtHandler No extension handlers found, not processing anything.
Apr 01 09:15:19 VM2 python3[1429]: 2025-04-01T09:15:19.671733Z INFO ExtHandler ExtHandler ProcessExtensionsGoalState completed [incarnation_1 3 ms]
Apr 01 09:15:19 VM2 python3[1429]: 2025-04-01T09:15:19.704158Z INFO ExtHandler ExtHandler Looking for existing remote access users.
Apr 01 09:15:19 VM2 python3[1429]: 2025-04-01T09:15:19.712639Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.12.0.2 is running as the goal st>
lines 1-21/21 (END)
```

- `cloud-init`

```bash
$ systemctl status cloud-init
● cloud-init.service - Cloud-init: Network Stage
     Loaded: loaded (/lib/systemd/system/cloud-init.service; enabled; vendor preset: enabled)
     Active: active (exited) since Tue 2025-04-01 09:15:05 UTC; 13min ago
   Main PID: 483 (code=exited, status=0/SUCCESS)
        CPU: 1.251s

Apr 01 09:15:05 VM2 cloud-init[489]: | B      o o+o.   |
Apr 01 09:15:05 VM2 cloud-init[489]: |o o  . o oo+o    |
Apr 01 09:15:05 VM2 cloud-init[489]: |o=.o  o . .o.+   |
Apr 01 09:15:05 VM2 cloud-init[489]: |O+o+...oS   o .  |
Apr 01 09:15:05 VM2 cloud-init[489]: |Bo. +.o.o  .     |
Apr 01 09:15:05 VM2 cloud-init[489]: |.. . = E .  .    |
Apr 01 09:15:05 VM2 cloud-init[489]: |  . = . o  .     |
Apr 01 09:15:05 VM2 cloud-init[489]: |   o .   ..      |
Apr 01 09:15:05 VM2 cloud-init[489]: +----[SHA256]-----+
Apr 01 09:15:05 VM2 systemd[1]: Finished Cloud-init: Network Stage.
```

### La fameux LAN.

Comment faire un Lan ? Tu fou tes vm dans le même ressource group MDRRR

```bash
az vm create --name VM1 --location westeurope --resource-group TP2 --image Ubuntu2204 --size Standard_B1s --ssh-key-values "C:\Users\yanis\.ssh\admin01Azure.pub" --admin-username admin01

#VM1

$ ping 10.0.0.4
PING 10.0.0.4 (10.0.0.4) 56(84) bytes of data.
64 bytes from 10.0.0.4: icmp_seq=1 ttl=64 time=4.19 ms
64 bytes from 10.0.0.4: icmp_seq=2 ttl=64 time=2.04 ms
64 bytes from 10.0.0.4: icmp_seq=3 ttl=64 time=2.23 ms
64 bytes from 10.0.0.4: icmp_seq=4 ttl=64 time=2.42 ms
64 bytes from 10.0.0.4: icmp_seq=5 ttl=64 time=2.22 ms
64 bytes from 10.0.0.4: icmp_seq=6 ttl=64 time=2.17 ms
64 bytes from 10.0.0.4: icmp_seq=7 ttl=64 time=1.99 ms
64 bytes from 10.0.0.4: icmp_seq=8 ttl=64 time=2.31 ms
^C
--- 10.0.0.4 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7009ms
rtt min/avg/max/mdev = 1.993/2.446/4.190/0.671 ms

#VM2

$ ping 10.0.0.5
PING 10.0.0.5 (10.0.0.5) 56(84) bytes of data.
64 bytes from 10.0.0.5: icmp_seq=1 ttl=64 time=2.97 ms
64 bytes from 10.0.0.5: icmp_seq=2 ttl=64 time=2.22 ms
64 bytes from 10.0.0.5: icmp_seq=3 ttl=64 time=2.55 ms
64 bytes from 10.0.0.5: icmp_seq=4 ttl=64 time=2.34 ms
64 bytes from 10.0.0.5: icmp_seq=5 ttl=64 time=2.22 ms
^C
--- 10.0.0.5 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4005ms
rtt min/avg/max/mdev = 2.216/2.458/2.966/0.281 ms
```

Ah et en référence a l'anomalie de cette partie : "c"

## Partie 2 : le cloud-init

### GOOOOOOOOOOOOOOO

It's time for the `cloud-init.txt`

```txt
#cloud-config
users:
  - default
  - name: admin01
    sudo: false
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkhnTET54sW84mfxsiXHbI8m0MBcOFMWxha3kJyfEDD yanis@Sec-Phoenix-PC

```

La commande pour créer la machine :

```bash
$ az vm create --name VM3 --resource-group TP2 --location westeurope --image Ubuntu2204 --size Standard_B1s --custom-data "G:\Mon Drive\EFREI\B2\Doc\Gérer parc informatique cloud\Infra-Cloud\tp2\cloud-init.txt" --ssh-key-value .\.ssh\admin01Azure.pub --admin-username admin01
```

Et ça marche :

```bash
$ ssh -i .\.ssh\admin01Azure admin01@20.229.147.255
The authenticity of host '20.229.147.255 (20.229.147.255)' can't be established.
ED25519 key fingerprint is SHA256:imrUMvtcS/rzrIkefFjiCZTZqAktWjV5gtPjYBlkJLY.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '20.229.147.255' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1021-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Apr  1 10:03:28 UTC 2025

  System load:  0.12              Processes:             105
  Usage of /:   5.2% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.6
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

admin01@VM3:~$
```

### Init-config personnaliser

```txt
#cloud-config
users:
  - default
  - name: admin01
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    passwd: 'gJ22rgT4#Admin01#'  # Use password directly for simplicity
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkhnTET54sW84mfxsiXHbI8m0MBcOFMWxha3kJyfEDD yanis@Sec-Phoenix-PC

package_update: true
package_upgrade: true

runcmd:
  - curl -fsSL https://get.docker.com |sh
  - docker pull alpine:latest
  - usermod -aG docker admin01
  - systemctl enable docker
  - systemctl start docker
```

Et ça marche

```bash
$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
alpine       latest    aded1e1a5b37   6 weeks ago   7.83MB
```

## Partie 3 : Terraform (Chiant l'install)

Toutes les vm / interfaces ont été delete avant de commencer.

### Premier déploiement :

- `az vm list`

```bash
az vm list
[
  {
    "additionalCapabilities": null,
    "applicationProfile": null,
    "availabilitySet": null,
    "billingProfile": null,
    "capacityReservation": null,
    "diagnosticsProfile": {
      "bootDiagnostics": {
        "enabled": false,
        "storageUri": null
      }
    },
    "etag": "\"1\"",
    "evictionPolicy": null,
    "extendedLocation": null,
    "extensionsTimeBudget": "PT1H30M",
    "hardwareProfile": {
      "vmSize": "Standard_F2",
      "vmSizeProperties": null
    },
    "host": null,
    "hostGroup": null,
    "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/TP2MAGUEULE-RESOURCES/providers/Microsoft.Compute/virtualMachines/tp2magueule-vm",
    "identity": null,
    "instanceView": null,
    "licenseType": null,
    "location": "westeurope",
    "managedBy": null,
    "name": "tp2magueule-vm",
    "networkProfile": {
      "networkApiVersion": null,
      "networkInterfaceConfigurations": null,
      "networkInterfaces": [
        {
          "deleteOption": null,
          "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp2magueule-resources/providers/Microsoft.Network/networkInterfaces/tp2magueule-nic1",
          "primary": true,
          "resourceGroup": "tp2magueule-resources"
        },
        {
          "deleteOption": null,
          "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp2magueule-resources/providers/Microsoft.Network/networkInterfaces/tp2magueule-nic2",
          "primary": false,
          "resourceGroup": "tp2magueule-resources"
        }
      ]
    },
    "osProfile": {
      "adminPassword": null,
      "adminUsername": "admin01",
      "allowExtensionOperations": true,
      "computerName": "tp2magueule-vm",
      "customData": null,
      "linuxConfiguration": {
        "disablePasswordAuthentication": true,
        "enableVmAgentPlatformUpdates": false,
        "patchSettings": {
          "assessmentMode": "ImageDefault",
          "automaticByPlatformSettings": null,
          "patchMode": "ImageDefault"
        },
        "provisionVmAgent": true,
        "ssh": {
          "publicKeys": [
            {
              "keyData": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkhnTET54sW84mfxsiXHbI8m0MBcOFMWxha3kJyfEDD yanis@Sec-Phoenix-PC\r\n",
              "path": "/home/admin01/.ssh/authorized_keys"
            }
          ]
        }
      },
      "requireGuestProvisionSignal": true,
      "secrets": [],
      "windowsConfiguration": null
    },
    "plan": null,
    "platformFaultDomain": null,
    "priority": "Regular",
    "provisioningState": "Succeeded",
    "proximityPlacementGroup": null,
    "resourceGroup": "TP2MAGUEULE-RESOURCES",
    "resources": null,
    "scheduledEventsPolicy": null,
    "scheduledEventsProfile": null,
    "securityProfile": null,
    "storageProfile": {
      "dataDisks": [],
      "diskControllerType": null,
      "imageReference": {
        "communityGalleryImageId": null,
        "exactVersion": "22.04.202503240",
        "id": null,
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sharedGalleryImageId": null,
        "sku": "22_04-lts",
        "version": "latest"
      },
      "osDisk": {
        "caching": "ReadWrite",
        "createOption": "FromImage",
        "deleteOption": "Detach",
        "diffDiskSettings": null,
        "diskSizeGb": 30,
        "encryptionSettings": null,
        "image": null,
        "managedDisk": {
          "diskEncryptionSet": null,
          "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp2magueule-resources/providers/Microsoft.Compute/disks/tp2magueule-vm_disk1_9813d0d95d7a4a058f74eec47b806ac7",
          "resourceGroup": "tp2magueule-resources",
          "securityProfile": null,
          "storageAccountType": "Standard_LRS"
        },
        "name": "tp2magueule-vm_disk1_9813d0d95d7a4a058f74eec47b806ac7",
        "osType": "Linux",
        "vhd": null,
        "writeAcceleratorEnabled": false
      }
    },
    "tags": {},
    "timeCreated": "2025-04-01T13:01:23.719906+00:00",
    "type": "Microsoft.Compute/virtualMachines",
    "userData": null,
    "virtualMachineScaleSet": null,
    "vmId": "b3a8826b-9f73-4e17-bc02-f39e11f6b672",
    "zones": null
  }
]
```

- `az vm show --name VM_NAME --resource-group RESOURCE_GROUP_NAME`

```bash
 az vm show --name tp2magueule-vm --resource-group TP2MAGUEULE-RESOURCES
{
  "additionalCapabilities": null,
  "applicationProfile": null,
  "availabilitySet": null,
  "billingProfile": null,
  "capacityReservation": null,
  "diagnosticsProfile": {
    "bootDiagnostics": {
      "enabled": false,
      "storageUri": null
    }
  },
  "etag": "\"1\"",
  "evictionPolicy": null,
  "extendedLocation": null,
  "extensionsTimeBudget": "PT1H30M",
  "hardwareProfile": {
    "vmSize": "Standard_F2",
    "vmSizeProperties": null
  },
  "host": null,
  "hostGroup": null,
  "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/TP2MAGUEULE-RESOURCES/providers/Microsoft.Compute/virtualMachines/tp2magueule-vm",
  "identity": null,
  "instanceView": null,
  "licenseType": null,
  "location": "westeurope",
  "managedBy": null,
  "name": "tp2magueule-vm",
  "networkProfile": {
    "networkApiVersion": null,
    "networkInterfaceConfigurations": null,
    "networkInterfaces": [
      {
        "deleteOption": null,
        "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp2magueule-resources/providers/Microsoft.Network/networkInterfaces/tp2magueule-nic1",
        "primary": true,
        "resourceGroup": "tp2magueule-resources"
      },
      {
        "deleteOption": null,
        "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp2magueule-resources/providers/Microsoft.Network/networkInterfaces/tp2magueule-nic2",
        "primary": false,
        "resourceGroup": "tp2magueule-resources"
      }
    ]
  },
  "osProfile": {
    "adminPassword": null,
    "adminUsername": "admin01",
    "allowExtensionOperations": true,
    "computerName": "tp2magueule-vm",
    "customData": null,
    "linuxConfiguration": {
      "disablePasswordAuthentication": true,
      "enableVmAgentPlatformUpdates": false,
      "patchSettings": {
        "assessmentMode": "ImageDefault",
        "automaticByPlatformSettings": null,
        "patchMode": "ImageDefault"
      },
      "provisionVmAgent": true,
      "ssh": {
        "publicKeys": [
          {
            "keyData": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkhnTET54sW84mfxsiXHbI8m0MBcOFMWxha3kJyfEDD yanis@Sec-Phoenix-PC\r\n",
            "path": "/home/admin01/.ssh/authorized_keys"
          }
        ]
      }
    },
    "requireGuestProvisionSignal": true,
    "secrets": [],
    "windowsConfiguration": null
  },
  "plan": null,
  "platformFaultDomain": null,
  "priority": "Regular",
  "provisioningState": "Succeeded",
  "proximityPlacementGroup": null,
  "resourceGroup": "TP2MAGUEULE-RESOURCES",
  "resources": null,
  "scheduledEventsPolicy": null,
  "scheduledEventsProfile": null,
  "securityProfile": null,
  "storageProfile": {
    "dataDisks": [],
    "diskControllerType": null,
    "imageReference": {
      "communityGalleryImageId": null,
      "exactVersion": "22.04.202503240",
      "id": null,
      "offer": "0001-com-ubuntu-server-jammy",
      "publisher": "Canonical",
      "sharedGalleryImageId": null,
      "sku": "22_04-lts",
      "version": "latest"
    },
    "osDisk": {
      "caching": "ReadWrite",
      "createOption": "FromImage",
      "deleteOption": "Detach",
      "diffDiskSettings": null,
      "diskSizeGb": 30,
      "encryptionSettings": null,
      "image": null,
      "managedDisk": {
        "diskEncryptionSet": null,
        "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp2magueule-resources/providers/Microsoft.Compute/disks/tp2magueule-vm_disk1_9813d0d95d7a4a058f74eec47b806ac7",
        "resourceGroup": "tp2magueule-resources",
        "securityProfile": null,
        "storageAccountType": "Standard_LRS"
      },
      "name": "tp2magueule-vm_disk1_9813d0d95d7a4a058f74eec47b806ac7",
      "osType": "Linux",
      "vhd": null,
      "writeAcceleratorEnabled": false
    }
  },
  "tags": {},
  "timeCreated": "2025-04-01T13:01:23.719906+00:00",
  "type": "Microsoft.Compute/virtualMachines",
  "userData": null,
  "virtualMachineScaleSet": null,
  "vmId": "b3a8826b-9f73-4e17-bc02-f39e11f6b672",
  "zones": null
}
```

- `az group list`

```bash
az group list
[
  {
    "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp1",
    "location": "westeurope",
    "managedBy": null,
    "name": "tp1",
    "properties": {
      "provisioningState": "Succeeded"
    },
    "tags": null,
    "type": "Microsoft.Resources/resourceGroups"
  },
  {
    "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/NetworkWatcherRG",
    "location": "westeurope",
    "managedBy": null,
    "name": "NetworkWatcherRG",
    "properties": {
      "provisioningState": "Succeeded"
    },
    "tags": null,
    "type": "Microsoft.Resources/resourceGroups"
  },
  {
    "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/TP2",
    "location": "westeurope",
    "managedBy": null,
    "name": "TP2",
    "properties": {
      "provisioningState": "Succeeded"
    },
    "tags": null,
    "type": "Microsoft.Resources/resourceGroups"
  },
  {
    "id": "/subscriptions/68ecb9c5-f292-4d86-a129-3ac49e94f287/resourceGroups/tp2magueule-resources",
    "location": "westeurope",
    "managedBy": null,
    "name": "tp2magueule-resources",
    "properties": {
      "provisioningState": "Succeeded"
    },
    "tags": {},
    "type": "Microsoft.Resources/resourceGroups"
  }
]
```

## Do it yourself (oscu)

- `main.tf`

```

provider "azurerm" {
  features {}
  subscription_id = "Ouais ouais mais non du coup mdrrrrr"
}

# Ressource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

# Réseau Virtuel
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Sous-réseaux
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# IP Publique pour node1
resource "azurerm_public_ip" "node1_pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# Interfaces réseau
resource "azurerm_network_interface" "node1_nic" {
  name                = "${var.prefix}-nic1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.node1_pip.id
  }
}

resource "azurerm_network_interface" "node2_nic" {
  name                = "${var.prefix}-nic2"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Sécurité : Groupe de sécurité réseau (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-ICMP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_port_range     = "*"
    destination_address_prefix = "10.0.0.0/16"
  }
}

# Attacher le NSG aux sous-réseaux
resource "azurerm_subnet_network_security_group_association" "subnet1_nsg" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "subnet2_nsg" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Machines Virtuelles
resource "azurerm_linux_virtual_machine" "node1" {
  name                = "${var.prefix}-node1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username      = "admin01"

  network_interface_ids = [azurerm_network_interface.node1_nic.id]

  admin_ssh_key {
    username   = "admin01"
    public_key = file("C:/Users/admin01/.ssh/admin01Azure.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_linux_virtual_machine" "node2" {
  name                = "${var.prefix}-node2"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username      = "admin01"

  network_interface_ids = [azurerm_network_interface.node2_nic.id]

  admin_ssh_key {
    username   = "admin01"
    public_key = file("C:/Users/admin01/.ssh/admin01Azure.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

```

- `variable.tf`

```terraform
variable "prefix" {
  description = "Le préfixe des ressources"
  type        = string
  default     = "VMM"
}

variable "location" {
  description = "La région Azure"
  type        = string
  default     = "westeurope"
}

variable "vm_size" {
  description = "La taille de la machine virtuelle"
  type        = string
  default     = "Standard_B1s"
}

```

### Vérification

- `ssh machine 1`

```bash
ssh -i .\.ssh\admin01Azure admin01@20.224.237.178
The authenticity of host '20.224.237.178 (20.224.237.178)' can't be established.
ED25519 key fingerprint is SHA256:hLbzN5/B3CnVz7BKjMADRHr76zC5NMfXgksZxKrHJL8.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '20.224.237.178' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1021-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Apr  1 13:48:33 UTC 2025

  System load:  0.27              Processes:             119
  Usage of /:   5.3% of 28.89GB   Users logged in:       0
  Memory usage: 30%               IPv4 address for eth0: 10.0.1.4
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
```

- `ping machine 2` (pas d'ip publiiiique)

```bash
$ping 10.0.2.4
PING 10.0.2.4 (10.0.2.4) 56(84) bytes of data.
64 bytes from 10.0.2.4: icmp_seq=1 ttl=64 time=1.35 ms
64 bytes from 10.0.2.4: icmp_seq=2 ttl=64 time=1.20 ms
64 bytes from 10.0.2.4: icmp_seq=3 ttl=64 time=1.23 ms
64 bytes from 10.0.2.4: icmp_seq=4 ttl=64 time=2.09 ms
^C
--- 10.0.2.4 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 1.200/1.465/2.086/0.362 ms
```

## Cloud-init time

![kirby-abyss](https://github.com/Phoenix0108/Infra-Cloud/blob/3c518e72d3295991f6cde5f8da78740224e6f4c2/tp2/kirby-abyss.gif)
