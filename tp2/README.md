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
```

Et ça marche

```bash
$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
alpine       latest    aded1e1a5b37   6 weeks ago   7.83MB
```

## Partie 3 : Terraform (Chiant l'install)
