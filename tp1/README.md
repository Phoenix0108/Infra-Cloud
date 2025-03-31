# TP 1 : Docker goes BRRRRRRRR

## Partie 1 :

### Instalation de Docker sur Ubuntu

Quoi ? Tu veux instaler docker et tu ne sais pas comment faire !!!!!

Et bah tu sais quoi ?

#### RTFM

Plus sérieusement il faut suivre la documentation. Les commandes nécéssaires pour installer sont ci-dessous :

- APT repositories :

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

```

- Docker installation :

```bash
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Test :

 sudo docker run hello-world

```

- Résultat de la commande docker run dans la vm :

```
admin01@VM1:~$  sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
e6590344b1a5: Pull complete
Digest: sha256:7e1a4e2d11e2ac7a8c3f768d4166c2defeb09d2a750b010412b6ea13de1efb19
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

Une fois l'install fini, je lance docker :

```bash
$ sudo systemctl start docker
```

Et je crée l'utilisateur demandé :

```bash
$ sudo usermod -aG docker $(whoami)
```

### Vérification de l'installation

Je préviens : le copier coller va être aussi violent qu'un Américain qui trouve du pétrole au moyen orient.

- `docker info`

```bash
$ docker info
Client: Docker Engine - Community
Version:    28.0.4
Context:    default
Debug Mode: false
Plugins:
 buildx: Docker Buildx (Docker Inc.)
   Version:  v0.22.0
   Path:     /usr/libexec/docker/cli-plugins/docker-buildx
 compose: Docker Compose (Docker Inc.)
   Version:  v2.34.0
   Path:     /usr/libexec/docker/cli-plugins/docker-compose

Server:
Containers: 1
 Running: 0
 Paused: 0
 Stopped: 1
Images: 1
Server Version: 28.0.4
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Using metacopy: false
 Native Overlay Diff: false
 userxattr: false
Logging Driver: json-file
Cgroup Driver: systemd
Cgroup Version: 2
Plugins:
 Volume: local
 Network: bridge host ipvlan macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
Swarm: inactive
Runtimes: runc io.containerd.runc.v2
Default Runtime: runc
Init Binary: docker-init
containerd version: 753481ec61c7c8955a23d6ff7bc8e4daed455734
runc version: v1.2.5-0-g59923ef
init version: de40ad0
Security Options:
 apparmor
 seccomp
  Profile: builtin
 cgroupns
Kernel Version: 6.8.0-1021-azure
Operating System: Ubuntu 24.04.2 LTS
OSType: linux
Architecture: x86_64
CPUs: 1
Total Memory: 892.9MiB
Name: VM1
ID: 9675ee65-9ec7-4da3-b88e-5181dede2f6e
Docker Root Dir: /var/lib/docker
Debug Mode: false
Experimental: false
Insecure Registries:
 ::1/128
 127.0.0.0/8
Live Restore Enabled: false
```

- `docker ps`

```bash
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

Iln'y a rien car rien n'est actif.

- `docker ps -a`

```bash
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
3a886b8e64d3   hello-world   "/hello"   52 seconds ago   Exited (0) 50 seconds ago             wizardly_einstein
fa4780704fb9   hello-world   "/hello"   16 minutes ago   Exited (0) 16 minutes ago             jovial_cray
```
