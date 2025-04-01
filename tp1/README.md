# TP 1 : Docker goes BRRRRRRRR

## Partie 1 :

### 🌞 Instalation de Docker sur Ubuntu

Quoi ? Tu veux instaler docker et tu ne sais pas comment faire !!!!!

Et bah tu sais quoi ?

#### RTFM

Plus sérieusement il faut suivre la documentation. Les commandes nécéssaires pour installer sous ubuntu sont ci-dessous :

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

### Vérification de l'installation (cette partie est pour moi. Aucun résultat de commande n'est présent.)

- `docker info`

```bash
# Info sur l'install actuelle de Docker
$ docker info

# Liste des conteneurs actifs
$ docker ps
# Liste de tous les conteneurs
$ docker ps -a

# Liste des images disponibles localement
$ docker images

# Lancer un conteneur debian
$ docker run debian

# -d sert à mettre un conteneur en tâche de fond (-d pour daemon)
$ docker run -d debian sleep 99999

# à l'inverse, -it sert à avoir un shell interactif (incompatible avec -d)
$ docker run -it debian bash

# Consulter les logs d'un conteneur
$ docker ps # on repère l'ID/le nom du conteneur voulu
$ docker logs <ID_OR_NAME>
$ docker logs -f <ID_OR_NAME> # suit l'arrivée des logs en temps réel

# Exécuter un processus dans un conteneur actif
$ docker ps # on repère l'ID/le nom du conteneur voulu
$ docker exec <ID_OR_NAME> <COMMAND>
$ docker exec <ID_OR_NAME> ls
$ docker exec -it <ID_OR_NAME> bash # permet de récupérer un shell bash dans le conteneur ciblé

# supprimer un conteneur donné
$ docker rm <ID_OR_NAME>
# supprimer un conteneur donné, même s'il est allumé
$ docker rm -f <ID_OR_NAME>

$ docker --help
$ docker run --help
$ man docker

```

### 🌞 Lancement de conteneurs

- Les commandes de bases :

```bash
# L'option --name permet de définir un nom pour le conteneur
$ docker run --name web nginx

# L'option -d permet de lancer un conteneur en tâche de fond
$ docker run --name web -d nginx

# L'option -v permet de partager un dossier/un fichier entre l'hôte et le conteneur
$ docker run --name web -d -v /path/to/html:/usr/share/nginx/html nginx

# L'option -p permet de partager un port entre l'hôte et le conteneur
$ docker run --name web -d -v /path/to/html:/usr/share/nginx/html -p 8888:80 nginx
# Dans l'exemple ci-dessus, le port 8888 de l'hôte est partagé vers le port 80 du conteneur

```

- Utiliser la commande docker run

```bash
$ docker run --name web -d -v /home/admin01/html:/usr/share/nginx/html -p 9999:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
6e909acdb790: Pull complete
5eaa34f5b9c2: Pull complete
417c4bccf534: Pull complete
e7e0ca015e55: Pull complete
373fe654e984: Pull complete
97f5c0f51d43: Pull complete
c22eb46e871a: Pull complete
Digest: sha256:124b44bfc9ccd1f3cedf4b592d4d1e8bddb78b51ec2ed5056c52d3692baebc19
Status: Downloaded newer image for nginx:latest
4f6971adf7e3b38cc890dfa266344b7601b33fdaf8c32a1f97177fb6c4ef1c69
```

Avec cette commande, je redirige le port 9999 vers le port 80 du conteneur.

J'ai du créer une rêgle sur le parefeu Azure pour autoriser le trafique vers ce port.

- Caractéristique de la règle parefeu

```
- Port : 9999
- Source : Any
- Destination : by default
```

- Résultat du curl (ma machine)

```bash
 curl http://108.143.166.187:9999

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html lang="fr">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Guerre Rouge - Destiny 2</title>
                        <style>
                      ...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 951
                    Content-Type: text/html
                    Date: Mon, 31 Mar 2025 10:01:24 GMT
                    ETag: "67ea67db-3b7"
                    Last-Modified: Mon, 31 Mar 2025 ...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 951], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 951
```

- Custom de nginx

Création du docker :

```bash
$ docker run --name meow -d -v /home/admin01/html:/usr/share/nginx/html -v /home/admin01/nginx.conf:/etc/nginx/conf.d/default.conf -p 7777:7777 nginx

```

- fichier de configuration nginx

```bash
server {

  listen 7777;

  root /usr/share/nginx/html;
}
```

## 🌞 Partie 2 : Dockerfile time !

La création du dockerfile prendra une image ubuntu. Pourquoi changer en cour de route ?

-`Dockerfile`

```Dockerfile
FROM ubuntu

RUN apt-get update -y && apt-get install apache2 -y

# Cette ligne me permet d'éviter une érreur

RUN mkdir -p /etc/apache2/logs /var/log/apache2

COPY ./index.html /var/www/html

COPY ./apache2.conf /etc/apache2/apache2.conf

# Cette ligne me permet d'éviter une érreur

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
```

## Partie 3 : doker-compose

### WikiJS

Le plus gros copier coller du monde :

```yml
services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: wiki
      POSTGRES_PASSWORD: wikijsrocks
      POSTGRES_USER: wikijs
    logging:
      driver: none
    restart: unless-stopped
    volumes:
      - db-data:/var/lib/postgresql/data

  wiki:
    image: ghcr.io/requarks/wiki:2
    depends_on:
      - db
    environment:
      DB_TYPE: postgres
      DB_HOST: db
      DB_PORT: 5432
      DB_USER: wikijs
      DB_PASS: wikijsrocks
      DB_NAME: wiki
    restart: unless-stopped
    ports:
      - "80:3000"

volumes:
  db-data:
```

`docker-compose up` pour lancer.

### APP python

Pour up l'app python, il faut un `Dockerfile` et un `docker-compose`

- `Dockerfile`

```Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY ./theapp /app

RUN pip install -r requirements.txt

EXPOSE 8888

CMD ["python", "app.py"]
```

- `docker-compose`

```yml
version: "3.8"

services:
  app:
    build: .
    container_name: meow_py
    ports:
      - "8888:8888"
    depends_on:
      - db
    environment:
      - REDIS_HOST=db
      - REDIS_PORT=6379

  db:
    image: redis:latest
    container_name: redis_db
    restart: always
```

Voila tout pour la partie 3

## Partie 4 : Docker security

### Root sans être root.

On peut prouver facilement que je suis root via le groupe docker. Pour ce vaire, voici la commande :

```bash
docker run --rm -v /etc/shadow:/etc/shadow:ro ubuntu cat /etc/shadow

Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
5a7813e071bf: Already exists
Digest: sha256:72297848456d5d37d1262630108ab308d3e9ec7ed1c3286a32fe09856619a782
Status: Downloaded newer image for ubuntu:latest
root:*:20140:0:99999:7:::
daemon:*:20140:0:99999:7:::
bin:*:20140:0:99999:7:::
sys:*:20140:0:99999:7:::
sync:*:20140:0:99999:7:::
games:*:20140:0:99999:7:::
man:*:20140:0:99999:7:::
lp:*:20140:0:99999:7:::
mail:*:20140:0:99999:7:::
news:*:20140:0:99999:7:::
uucp:*:20140:0:99999:7:::
proxy:*:20140:0:99999:7:::
www-data:*:20140:0:99999:7:::
backup:*:20140:0:99999:7:::
list:*:20140:0:99999:7:::
irc:*:20140:0:99999:7:::
_apt:*:20140:0:99999:7:::
nobody:*:20140:0:99999:7:::
systemd-network:!*:20140::::::
systemd-timesync:!*:20140::::::
dhcpcd:!:20140::::::
messagebus:!:20140::::::
syslog:!:20140::::::
systemd-resolve:!*:20140::::::
uuidd:!:20140::::::
tss:!:20140::::::
sshd:!:20140::::::
pollinate:!:20140::::::
tcpdump:!:20140::::::
landscape:!:20140::::::
fwupd-refresh:!*:20140::::::
polkitd:!*:20140::::::
_chrony:!:20140::::::
admin01:!:20178:0:99999:7:::
```

Dites bonjour au contenue du fichier shadow.

### Scan avec trivy

- `wikijs`

```bash
$ trivy image ghcr.io/requarks/wiki:2 | tail -n20
2025-03-31T14:58:51+02:00       INFO    [vulndb] Need to update DB
2025-03-31T14:58:51+02:00       INFO    [vulndb] Downloading vulnerability DB...
2025-03-31T14:58:51+02:00       INFO    [vulndb] Downloading artifact...        repo="mirror.gcr.io/aquasec/trivy-db:2"
61.66 MiB / 61.66 MiB [-----------------------------------------------------------------------------------------------------------------------------------------] 100.00% 8.62 MiB p/s 7.4s
2025-03-31T14:58:58+02:00       INFO    [vulndb] Artifact successfully downloaded       repo="mirror.gcr.io/aquasec/trivy-db:2"
2025-03-31T14:58:58+02:00       INFO    [vuln] Vulnerability scanning is enabled
2025-03-31T14:58:58+02:00       INFO    [secret] Secret scanning is enabled
2025-03-31T14:58:58+02:00       INFO    [secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2025-03-31T14:58:58+02:00       INFO    [secret] Please see also https://aquasecurity.github.io/trivy/dev/docs/scanner/secret#recommendation for faster secret detection
2025-03-31T14:59:13+02:00       INFO    Detected OS     family="alpine" version="3.21.3"
2025-03-31T14:59:13+02:00       WARN    This OS version is not on the EOL list  family="alpine" version="3.21"
2025-03-31T14:59:13+02:00       INFO    [alpine] Detecting vulnerabilities...   os_version="3.21" repository="3.21" pkg_num=71
2025-03-31T14:59:13+02:00       INFO    Number of language-specific files       num=1
2025-03-31T14:59:13+02:00       INFO    [node-pkg] Detecting vulnerabilities...
2025-03-31T14:59:13+02:00       INFO    Table result includes only package filenames. Use '--format json' option to get the full path to the package file.
│                                     │                     │          │          │                   │                                    │                                               
              │
│                                     │                     │          │          │                   │                                    │                                               
              │
│                                     ├─────────────────────┼──────────┤          │                   ├────────────────────────────────────┼───────────────────────────────────────────────
───────────────┤
│                                     │ CVE-2021-32640      │ MEDIUM   │          │                   │ 7.4.6, 6.2.2, 5.2.3                │ nodejs-ws: Specially crafted value of the     
              │
│                                     │                     │          │          │                   │                                    │ `Sec-Websocket-Protocol` header can be used to
...            │
│                                     │                     │          │          │                   │                                    │ https://avd.aquasec.com/nvd/cve-2021-32640    
              │
│                                     │                     │          │          │                   │                                    │                                               
              │
│                                     │                     │          │          │                   │                                    │                                               
              │
│                                     │                     │          │          │                   │                                    │                                               
              │
│                                     │                     │          │          │                   │                                    │                                               
              │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼────────────────────────────────────┼───────────────────────────────────────────────
───────────────┤
│ xml2js (package.json)               │ CVE-2023-0842       │          │          │ 0.4.19            │ 0.5.0                              │ node-xml2js: xml2js is vulnerable to prototype
pollution     │
│                                     │                     │          │          │                   │                                    │ https://avd.aquasec.com/nvd/cve-2023-0842     
              │
│                                     │                     │          │          ├───────────────────┤                                    │                                               
              │
│                                     │                     │          │          │ 0.4.23            │                                    │                                               
              │
│                                     │                     │          │          │                   │                                    │                                               
              │
│                                     │                     │          │          ├───────────────────┤                                    │                                               
              │
│                                     │                     │          │          │ 0.4.4             │                                    │                                               
              │
│                                     │                     │          │          │                   │                                    │                                               
              │
└─────────────────────────────────────┴─────────────────────┴──────────┴──────────┴───────────────────┴────────────────────────────────────┴───────────────────────────────────────────────
───────────────┘
```

- `postgres`

```bash
$ trivy image postgres:15-alpine | tail -20
2025-03-31T13:03:25Z    INFO    [vulndb] Need to update DB
2025-03-31T13:03:25Z    INFO    [vulndb] Downloading vulnerability DB...
2025-03-31T13:03:25Z    INFO    [vulndb] Downloading artifact...        repo="mirror.gcr.io/aquasec/trivy-db:2"
61.66 MiB / 61.66 MiB [------------------------------------------------------------------------------------------------------------------------------------------] 100.00% 4.37 MiB p/s 14s
2025-03-31T13:03:40Z    INFO    [vulndb] Artifact successfully downloaded       repo="mirror.gcr.io/aquasec/trivy-db:2"
2025-03-31T13:03:40Z    INFO    [vuln] Vulnerability scanning is enabled
2025-03-31T13:03:40Z    INFO    [secret] Secret scanning is enabled
2025-03-31T13:03:40Z    INFO    [secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2025-03-31T13:03:40Z    INFO    [secret] Please see also https://trivy.dev/v0.61/docs/scanner/secret#recommendation for faster secret detection
2025-03-31T13:04:10Z    INFO    Detected OS     family="alpine" version="3.21.3"
2025-03-31T13:04:10Z    INFO    [alpine] Detecting vulnerabilities...   os_version="3.21" repository="3.21" pkg_num=46
2025-03-31T13:04:11Z    INFO    Number of language-specific files       num=1
2025-03-31T13:04:11Z    INFO    [gobinary] Detecting vulnerabilities...
2025-03-31T13:04:11Z    WARN    Using severities from other vendors for some vulnerabilities. Read https://trivy.dev/v0.61/docs/scanner/vulnerability#severity-selection for details.
│         │ CVE-2024-34158 │          │        │                   │                                  │ go/build/constraint: golang: Calling Parse on a "// +build"  │
│         │                │          │        │                   │                                  │ build tag line with...                                       │
│         │                │          │        │                   │                                  │ https://avd.aquasec.com/nvd/cve-2024-34158                   │
│         ├────────────────┤          │        │                   ├──────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│         │ CVE-2024-45336 │          │        │                   │ 1.22.11, 1.23.5, 1.24.0-rc.2     │ golang: net/http: net/http: sensitive headers incorrectly    │
│         │                │          │        │                   │                                  │ sent after cross-domain redirect                             │
│         │                │          │        │                   │                                  │ https://avd.aquasec.com/nvd/cve-2024-45336                   │
│         ├────────────────┤          │        │                   │                                  ├──────────────────────────────────────────────────────────────┤
│         │ CVE-2024-45341 │          │        │                   │                                  │ golang: crypto/x509: crypto/x509: usage of IPv6 zone IDs can │
│         │                │          │        │                   │                                  │ bypass URI name...                                           │
│         │                │          │        │                   │                                  │ https://avd.aquasec.com/nvd/cve-2024-45341                   │
│         ├────────────────┤          │        │                   ├──────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│         │ CVE-2025-22866 │          │        │                   │ 1.22.12, 1.23.6, 1.24.0-rc.3     │ crypto/internal/nistec: golang: Timing sidechannel for P-256 │
│         │                │          │        │                   │                                  │ on ppc64le in crypto/internal/nistec                         │
│         │                │          │        │                   │                                  │ https://avd.aquasec.com/nvd/cve-2025-22866                   │
│         ├────────────────┼──────────┤        │                   ├──────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│         │ CVE-2022-30629 │ LOW      │        │                   │ 1.17.11, 1.18.3                  │ golang: crypto/tls: session tickets lack random              │
│         │                │          │        │                   │                                  │ ticket_age_add                                               │
│         │                │          │        │                   │                                  │ https://avd.aquasec.com/nvd/cve-2022-30629                   │
└─────────┴────────────────┴──────────┴────────┴───────────────────┴──────────────────────────────────┴──────────────────────────────────────────────────────────────┘
```

- `Apache`

```bash
$ trivy image hooray:latest | tail -20
2025-03-31T13:05:03Z    INFO    [vuln] Vulnerability scanning is enabled
2025-03-31T13:05:03Z    INFO    [secret] Secret scanning is enabled
2025-03-31T13:05:03Z    INFO    [secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2025-03-31T13:05:03Z    INFO    [secret] Please see also https://trivy.dev/v0.61/docs/scanner/secret#recommendation for faster secret detection
2025-03-31T13:05:03Z    INFO    Detected OS     family="alpine" version="3.21.3"
2025-03-31T13:05:03Z    INFO    [alpine] Detecting vulnerabilities...   os_version="3.21" repository="3.21" pkg_num=21
2025-03-31T13:05:03Z    INFO    Number of language-specific files       num=0

Report Summary

┌───────────────────────────────┬────────┬─────────────────┬─────────┐
│            Target             │  Type  │ Vulnerabilities │ Secrets │
├───────────────────────────────┼────────┼─────────────────┼─────────┤
│ hooray:latest (alpine 3.21.3) │ alpine │        0        │    -    │
└───────────────────────────────┴────────┴─────────────────┴─────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)
```

- `nginx`

```bash
nginx (debian 12.10)

Total: 148 (UNKNOWN: 0, LOW: 98, MEDIUM: 36, HIGH: 12, CRITICAL: 2)

┌────────────────────┬─────────────────────┬──────────┬──────────────┬─────────────────────────┬──────────────────┬──────────────────────────────────────────────────────────────┐
│      Library       │    Vulnerability    │ Severity │    Status    │    Installed Version    │  Fixed Version   │                            Title                             │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ apt                │ CVE-2011-3374       │ LOW      │ affected     │ 2.6.1                   │                  │ It was found that apt-key in apt, all versions, do not       │
│                    │                     │          │              │                         │                  │ correctly...                                                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2011-3374                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ bash               │ TEMP-0841856-B18BAF │          │              │ 5.2.15-2+b7             │                  │ [Privilege escalation possible to other user than root]      │
│                    │                     │          │              │                         │                  │ https://security-tracker.debian.org/tracker/TEMP-0841856-B1- │
│                    │                     │          │              │                         │                  │ 8BAF                                                         │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ bsdutils           │ CVE-2022-0563       │          │              │ 1:2.38.1-5+deb12u3      │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
│                    │                     │          │              │                         │                  │ and chsh when compiled...                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├────────────────────┼─────────────────────┤          ├──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ coreutils          │ CVE-2016-2781       │          │ will_not_fix │ 9.1-1                   │                  │ coreutils: Non-privileged session can escape to the parent   │
│                    │                     │          │              │                         │                  │ session in chroot                                            │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2016-2781                    │
│                    ├─────────────────────┤          ├──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2017-18018      │          │ affected     │                         │                  │ coreutils: race condition vulnerability in chown and chgrp   │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-18018                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ curl               │ CVE-2024-2379       │          │              │ 7.88.1-10+deb12u12      │                  │ curl: QUIC certificate check bypass with wolfSSL             │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-2379                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-0725       │          │              │                         │                  │ libcurl: Buffer Overflow in libcurl via zlib Integer         │
│                    │                     │          │              │                         │                  │ Overflow                                                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-0725                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ gcc-12-base        │ CVE-2022-27943      │          │              │ 12.2.0-14               │                  │ binutils: libiberty/rust-demangle.c in GNU GCC 11.2 allows   │
│                    │                     │          │              │                         │                  │ stack exhaustion in demangle_const                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-27943                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-4039       │          │              │                         │                  │ gcc: -fstack-protector fails to guard dynamic stack          │
│                    │                     │          │              │                         │                  │ allocations on ARM64                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-4039                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ gpgv               │ CVE-2022-3219       │          │              │ 2.2.40-1.1              │                  │ gnupg: denial of service issue (resource consumption) using  │
│                    │                     │          │              │                         │                  │ compressed packets                                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-3219                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-30258      │          │              │                         │                  │ gnupg: verification DoS due to a malicious subkey in the     │
│                    │                     │          │              │                         │                  │ keyring                                                      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-30258                   │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libabsl20220623    │ CVE-2025-0838       │ MEDIUM   │              │ 20220623.1-1            │                  │ abseil-cpp: Heap Buffer overflow in Abseil                   │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-0838                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libaom3            │ CVE-2023-6879       │ CRITICAL │              │ 3.6.0-1+deb12u1         │                  │ aom: heap-buffer-overflow on frame size change               │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-6879                    │
│                    ├─────────────────────┼──────────┼──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-39616      │ HIGH     │ will_not_fix │                         │                  │ AOMedia v3.0.0 to v3.5.0 was discovered to contain an        │
│                    │                     │          │              │                         │                  │ invalid read mem...                                          │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-39616                   │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libapt-pkg6.0      │ CVE-2011-3374       │ LOW      │ affected     │ 2.6.1                   │                  │ It was found that apt-key in apt, all versions, do not       │
│                    │                     │          │              │                         │                  │ correctly...                                                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2011-3374                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libblkid1          │ CVE-2022-0563       │          │              │ 2.38.1-5+deb12u3        │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
│                    │                     │          │              │                         │                  │ and chsh when compiled...                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libc-bin           │ CVE-2010-4756       │          │              │ 2.36-9+deb12u10         │                  │ glibc: glob implementation can cause excessive CPU and       │
│                    │                     │          │              │                         │                  │ memory consumption due to...                                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2010-4756                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-20796      │          │              │                         │                  │ glibc: uncontrolled recursion in function                    │
│                    │                     │          │              │                         │                  │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-20796                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010022    │          │              │                         │                  │ glibc: stack guard protection bypass                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010022                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010023    │          │              │                         │                  │ glibc: running ldd on malicious ELF leads to code execution  │
│                    │                     │          │              │                         │                  │ because of...                                                │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010023                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010024    │          │              │                         │                  │ glibc: ASLR bypass using cache of thread stack and heap      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010024                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010025    │          │              │                         │                  │ glibc: information disclosure of heap addresses of           │
│                    │                     │          │              │                         │                  │ pthread_created thread                                       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010025                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-9192       │          │              │                         │                  │ glibc: uncontrolled recursion in function                    │
│                    │                     │          │              │                         │                  │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-9192                    │
├────────────────────┼─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│ libc6              │ CVE-2010-4756       │          │              │                         │                  │ glibc: glob implementation can cause excessive CPU and       │
│                    │                     │          │              │                         │                  │ memory consumption due to...                                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2010-4756                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-20796      │          │              │                         │                  │ glibc: uncontrolled recursion in function                    │
│                    │                     │          │              │                         │                  │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-20796                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010022    │          │              │                         │                  │ glibc: stack guard protection bypass                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010022                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010023    │          │              │                         │                  │ glibc: running ldd on malicious ELF leads to code execution  │
│                    │                     │          │              │                         │                  │ because of...                                                │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010023                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010024    │          │              │                         │                  │ glibc: ASLR bypass using cache of thread stack and heap      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010024                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-1010025    │          │              │                         │                  │ glibc: information disclosure of heap addresses of           │
│                    │                     │          │              │                         │                  │ pthread_created thread                                       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-1010025                 │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2019-9192       │          │              │                         │                  │ glibc: uncontrolled recursion in function                    │
│                    │                     │          │              │                         │                  │ check_dst_limits_calc_pos_1 in posix/regexec.c               │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2019-9192                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libcap2            │ CVE-2025-1390       │ MEDIUM   │              │ 1:2.66-4                │                  │ libcap: pam_cap: Fix potential configuration parsing error   │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-1390                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libcurl4           │ CVE-2024-2379       │ LOW      │              │ 7.88.1-10+deb12u12      │                  │ curl: QUIC certificate check bypass with wolfSSL             │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-2379                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-0725       │          │              │                         │                  │ libcurl: Buffer Overflow in libcurl via zlib Integer         │
│                    │                     │          │              │                         │                  │ Overflow                                                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-0725                    │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libdav1d6          │ CVE-2023-32570      │ MEDIUM   │ will_not_fix │ 1.0.0-2+deb12u1         │                  │ VideoLAN dav1d before 1.2.0 has a thread_task.c race         │
│                    │                     │          │              │                         │                  │ condition that ca ......                                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-32570                   │
├────────────────────┼─────────────────────┤          ├──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libde265-0         │ CVE-2023-51792      │          │ affected     │ 1.0.11-1+deb12u2        │                  │ Buffer Overflow vulnerability in libde265 v1.0.12 allows a   │
│                    │                     │          │              │                         │                  │ local attac ...                                              │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-51792                   │
│                    ├─────────────────────┤          ├──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-38949      │          │ fix_deferred │                         │                  │ Heap Buffer Overflow vulnerability in Libde265 v1.0.15       │
│                    │                     │          │              │                         │                  │ allows attacker ...                                          │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-38949                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-38950      │          │              │                         │                  │ Heap Buffer Overflow vulnerability in Libde265 v1.0.15       │
│                    │                     │          │              │                         │                  │ allows attacker ...                                          │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-38950                   │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libexpat1          │ CVE-2023-52425      │ HIGH     │ affected     │ 2.5.0-1+deb12u1         │                  │ expat: parsing large tokens can trigger a denial of service  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-52425                   │
│                    ├─────────────────────┤          ├──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-8176       │          │ will_not_fix │                         │                  │ libexpat: expat: Improper Restriction of XML Entity          │
│                    │                     │          │              │                         │                  │ Expansion Depth in libexpat                                  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-8176                    │
│                    ├─────────────────────┼──────────┼──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-50602      │ MEDIUM   │ affected     │                         │                  │ libexpat: expat: DoS via XML_ResumeParser                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-50602                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-52426      │ LOW      │              │                         │                  │ expat: recursive XML entity expansion vulnerability          │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-52426                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-28757      │          │              │                         │                  │ expat: XML Entity Expansion                                  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-28757                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libgcc-s1          │ CVE-2022-27943      │          │              │ 12.2.0-14               │                  │ binutils: libiberty/rust-demangle.c in GNU GCC 11.2 allows   │
│                    │                     │          │              │                         │                  │ stack exhaustion in demangle_const                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-27943                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-4039       │          │              │                         │                  │ gcc: -fstack-protector fails to guard dynamic stack          │
│                    │                     │          │              │                         │                  │ allocations on ARM64                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-4039                    │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libgcrypt20        │ CVE-2024-2236       │ MEDIUM   │ fix_deferred │ 1.10.1-3                │                  │ libgcrypt: vulnerable to Marvin Attack                       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-2236                    │
│                    ├─────────────────────┼──────────┼──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-6829       │ LOW      │ affected     │                         │                  │ libgcrypt: ElGamal implementation doesn't have semantic      │
│                    │                     │          │              │                         │                  │ security due to incorrectly encoded plaintexts...            │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-6829                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libgnutls30        │ CVE-2011-3389       │          │              │ 3.7.9-2+deb12u4         │                  │ HTTPS: block-wise chosen-plaintext attack against SSL/TLS    │
│                    │                     │          │              │                         │                  │ (BEAST)                                                      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2011-3389                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libgssapi-krb5-2   │ CVE-2024-26462      │ MEDIUM   │              │ 1.20.1-2+deb12u2        │                  │ krb5: Memory leak at /krb5/src/kdc/ndr.c                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26462                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-24528      │          │              │                         │                  │ krb5: overflow when calculating ulog block size              │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-24528                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-5709       │ LOW      │              │                         │                  │ krb5: integer overflow in dbentry->n_key_data in             │
│                    │                     │          │              │                         │                  │ kadmin/dbutil/dump.c                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26458      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26461      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libheif1           │ CVE-2023-49463      │          │              │ 1.15.1-1+deb12u1        │                  │ libheif v1.17.5 was discovered to contain a segmentation     │
│                    │                     │          │              │                         │                  │ violation via ...                                            │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-49463                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-25269      │          │              │                         │                  │ libheif <= 1.17.6 contains a memory leak in the function     │
│                    │                     │          │              │                         │                  │ JpegEncoder:: ......                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-25269                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libjbig0           │ CVE-2017-9937       │          │              │ 2.1-6.1                 │                  │ libtiff: memory malloc failure in tif_jbig.c could cause     │
│                    │                     │          │              │                         │                  │ DOS.                                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-9937                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libk5crypto3       │ CVE-2024-26462      │ MEDIUM   │              │ 1.20.1-2+deb12u2        │                  │ krb5: Memory leak at /krb5/src/kdc/ndr.c                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26462                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-24528      │          │              │                         │                  │ krb5: overflow when calculating ulog block size              │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-24528                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-5709       │ LOW      │              │                         │                  │ krb5: integer overflow in dbentry->n_key_data in             │
│                    │                     │          │              │                         │                  │ kadmin/dbutil/dump.c                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26458      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26461      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├────────────────────┼─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│ libkrb5-3          │ CVE-2024-26462      │ MEDIUM   │              │                         │                  │ krb5: Memory leak at /krb5/src/kdc/ndr.c                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26462                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-24528      │          │              │                         │                  │ krb5: overflow when calculating ulog block size              │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-24528                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-5709       │ LOW      │              │                         │                  │ krb5: integer overflow in dbentry->n_key_data in             │
│                    │                     │          │              │                         │                  │ kadmin/dbutil/dump.c                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26458      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26461      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├────────────────────┼─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│ libkrb5support0    │ CVE-2024-26462      │ MEDIUM   │              │                         │                  │ krb5: Memory leak at /krb5/src/kdc/ndr.c                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26462                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-24528      │          │              │                         │                  │ krb5: overflow when calculating ulog block size              │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-24528                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-5709       │ LOW      │              │                         │                  │ krb5: integer overflow in dbentry->n_key_data in             │
│                    │                     │          │              │                         │                  │ kadmin/dbutil/dump.c                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-5709                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26458      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/rpc/pmap_rmt.c            │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26458                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-26461      │          │              │                         │                  │ krb5: Memory leak at /krb5/src/lib/gssapi/krb5/k5sealv3.c    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-26461                   │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libldap-2.5-0      │ CVE-2023-2953       │ HIGH     │              │ 2.5.13+dfsg-5           │                  │ openldap: null pointer dereference in ber_memalloc_x         │
│                    │                     │          │              │                         │                  │ function                                                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-2953                    │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2015-3276       │ LOW      │              │                         │                  │ openldap: incorrect multi-keyword mode cipherstring parsing  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2015-3276                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2017-14159      │          │              │                         │                  │ openldap: Privilege escalation via PID file manipulation     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-14159                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2017-17740      │          │              │                         │                  │ openldap: contrib/slapd-modules/nops/nops.c attempts to free │
│                    │                     │          │              │                         │                  │ stack buffer allowing remote attackers to cause...           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-17740                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2020-15719      │          │              │                         │                  │ openldap: Certificate validation incorrectly matches name    │
│                    │                     │          │              │                         │                  │ against CN-ID                                                │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2020-15719                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libmount1          │ CVE-2022-0563       │          │              │ 2.38.1-5+deb12u3        │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
│                    │                     │          │              │                         │                  │ and chsh when compiled...                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libpam-modules     │ CVE-2024-10041      │ MEDIUM   │              │ 1.5.2-6+deb12u1         │                  │ pam: libpam: Libpam vulnerable to read hashed password       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-10041                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-22365      │          │              │                         │                  │ pam: allowing unprivileged user to block another user        │
│                    │                     │          │              │                         │                  │ namespace                                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-22365                   │
├────────────────────┼─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│ libpam-modules-bin │ CVE-2024-10041      │          │              │                         │                  │ pam: libpam: Libpam vulnerable to read hashed password       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-10041                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-22365      │          │              │                         │                  │ pam: allowing unprivileged user to block another user        │
│                    │                     │          │              │                         │                  │ namespace                                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-22365                   │
├────────────────────┼─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│ libpam-runtime     │ CVE-2024-10041      │          │              │                         │                  │ pam: libpam: Libpam vulnerable to read hashed password       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-10041                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-22365      │          │              │                         │                  │ pam: allowing unprivileged user to block another user        │
│                    │                     │          │              │                         │                  │ namespace                                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-22365                   │
├────────────────────┼─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│ libpam0g           │ CVE-2024-10041      │          │              │                         │                  │ pam: libpam: Libpam vulnerable to read hashed password       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-10041                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-22365      │          │              │                         │                  │ pam: allowing unprivileged user to block another user        │
│                    │                     │          │              │                         │                  │ namespace                                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-22365                   │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libpng16-16        │ CVE-2021-4214       │ LOW      │              │ 1.6.39-2                │                  │ libpng: hardcoded value leads to heap-overflow               │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2021-4214                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libsmartcols1      │ CVE-2022-0563       │          │              │ 2.38.1-5+deb12u3        │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
│                    │                     │          │              │                         │                  │ and chsh when compiled...                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libssl3            │ CVE-2024-13176      │ MEDIUM   │              │ 3.0.15-1~deb12u1        │                  │ openssl: Timing side-channel in ECDSA signature computation  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-13176                   │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libstdc++6         │ CVE-2022-27943      │ LOW      │              │ 12.2.0-14               │                  │ binutils: libiberty/rust-demangle.c in GNU GCC 11.2 allows   │
│                    │                     │          │              │                         │                  │ stack exhaustion in demangle_const                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-27943                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-4039       │          │              │                         │                  │ gcc: -fstack-protector fails to guard dynamic stack          │
│                    │                     │          │              │                         │                  │ allocations on ARM64                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-4039                    │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libsystemd0        │ CVE-2013-4392       │          │              │ 252.36-1~deb12u1        │                  │ systemd: TOCTOU race condition when updating file            │
│                    │                     │          │              │                         │                  │ permissions and SELinux security contexts...                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2013-4392                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-31437      │          │              │                         │                  │ An issue was discovered in systemd 253. An attacker can      │
│                    │                     │          │              │                         │                  │ modify a...                                                  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31437                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-31438      │          │              │                         │                  │ An issue was discovered in systemd 253. An attacker can      │
│                    │                     │          │              │                         │                  │ truncate a...                                                │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31438                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-31439      │          │              │                         │                  │ An issue was discovered in systemd 253. An attacker can      │
│                    │                     │          │              │                         │                  │ modify the...                                                │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31439                   │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libtiff6           │ CVE-2023-52355      │ HIGH     │ will_not_fix │ 4.5.0-6+deb12u2         │                  │ libtiff: TIFFRasterScanlineSize64 produce too-big size and   │
│                    │                     │          │              │                         │                  │ could cause OOM                                              │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-52355                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-6277       │ MEDIUM   │              │                         │                  │ libtiff: Out-of-memory in TIFFOpen via a craft file          │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-6277                    │
│                    ├─────────────────────┼──────────┼──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2017-16232      │ LOW      │ affected     │                         │                  │ libtiff: Memory leaks in tif_open.c, tif_lzw.c, and          │
│                    │                     │          │              │                         │                  │ tif_aux.c                                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-16232                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2017-17973      │          │              │                         │                  │ libtiff: heap-based use after free in                        │
│                    │                     │          │              │                         │                  │ tiff2pdf.c:t2p_writeproc                                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-17973                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2017-5563       │          │              │                         │                  │ libtiff: Heap-buffer overflow in LZWEncode tif_lzw.c         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-5563                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2017-9117       │          │              │                         │                  │ libtiff: Heap-based buffer over-read in bmp2tiff             │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2017-9117                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2018-10126      │          │              │                         │                  │ libtiff: NULL pointer dereference in the jpeg_fdct_16x16     │
│                    │                     │          │              │                         │                  │ function in jfdctint.c                                       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2018-10126                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2022-1210       │          │              │                         │                  │ tiff: Malicious file leads to a denial of service in TIFF    │
│                    │                     │          │              │                         │                  │ File...                                                      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-1210                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-1916       │          │              │                         │                  │ libtiff: out-of-bounds read in extractImageSection() in      │
│                    │                     │          │              │                         │                  │ tools/tiffcrop.c                                             │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-1916                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-3164       │          │              │                         │                  │ libtiff: heap-buffer-overflow in extractImageSection()       │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-3164                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-6228       │          │              │                         │                  │ libtiff: heap-based buffer overflow in cpStripToTile() in    │
│                    │                     │          │              │                         │                  │ tools/tiffcp.c                                               │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-6228                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libtinfo6          │ CVE-2023-50495      │ MEDIUM   │              │ 6.4-4                   │                  │ ncurses: segmentation fault via _nc_wrap_entry()             │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-50495                   │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libudev1           │ CVE-2013-4392       │ LOW      │              │ 252.36-1~deb12u1        │                  │ systemd: TOCTOU race condition when updating file            │
│                    │                     │          │              │                         │                  │ permissions and SELinux security contexts...                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2013-4392                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-31437      │          │              │                         │                  │ An issue was discovered in systemd 253. An attacker can      │
│                    │                     │          │              │                         │                  │ modify a...                                                  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31437                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-31438      │          │              │                         │                  │ An issue was discovered in systemd 253. An attacker can      │
│                    │                     │          │              │                         │                  │ truncate a...                                                │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31438                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-31439      │          │              │                         │                  │ An issue was discovered in systemd 253. An attacker can      │
│                    │                     │          │              │                         │                  │ modify the...                                                │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31439                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libuuid1           │ CVE-2022-0563       │          │              │ 2.38.1-5+deb12u3        │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
│                    │                     │          │              │                         │                  │ and chsh when compiled...                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libxml2            │ CVE-2024-25062      │ HIGH     │              │ 2.9.14+dfsg-1.3~deb12u1 │                  │ libxml2: use-after-free in XMLReader                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-25062                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-56171      │          │              │                         │                  │ libxml2: Use-After-Free in libxml2                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-56171                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-24928      │          │              │                         │                  │ libxml2: Stack-based buffer overflow in xmlSnprintfElements  │
│                    │                     │          │              │                         │                  │ of libxml2                                                   │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-24928                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-27113      │          │              │                         │                  │ libxml2: NULL Pointer Dereference in libxml2 xmlPatMatch     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-27113                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2022-49043      │ MEDIUM   │              │                         │                  │ libxml: use-after-free in xmlXIncludeAddNode                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-49043                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-39615      │          │              │                         │                  │ libxml2: crafted xml can cause global buffer overflow        │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-39615                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-45322      │          │              │                         │                  │ libxml2: use-after-free in xmlUnlinkNode() in tree.c         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-45322                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-34459      │ LOW      │              │                         │                  │ libxml2: buffer over-read in xmlHTMLPrintFileContext in      │
│                    │                     │          │              │                         │                  │ xmllint.c                                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-34459                   │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ libxslt1.1         │ CVE-2024-55549      │ HIGH     │ fixed        │ 1.1.35-1                │ 1.1.35-1+deb12u1 │ libxslt: Use-After-Free in libxslt (xsltGetInheritedNsList)  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-55549                   │
│                    ├─────────────────────┤          │              │                         │                  ├──────────────────────────────────────────────────────────────┤
│                    │ CVE-2025-24855      │          │              │                         │                  │ libxslt: Use-After-Free in libxslt numbers.c                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2025-24855                   │
│                    ├─────────────────────┼──────────┼──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2015-9019       │ LOW      │ affected     │                         │                  │ libxslt: math.random() in xslt uses unseeded randomness      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2015-9019                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ login              │ CVE-2023-4641       │ MEDIUM   │              │ 1:4.13+dfsg1-1+b1       │                  │ shadow-utils: possible password leak during passwd(1) change │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-4641                    │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2007-5686       │ LOW      │              │                         │                  │ initscripts in rPath Linux 1 sets insecure permissions for   │
│                    │                     │          │              │                         │                  │ the /var/lo ......                                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2007-5686                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-29383      │          │              │                         │                  │ shadow: Improper input validation in shadow-utils package    │
│                    │                     │          │              │                         │                  │ utility chfn                                                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-29383                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-56433      │          │              │                         │                  │ shadow-utils: Default subordinate ID configuration in        │
│                    │                     │          │              │                         │                  │ /etc/login.defs could lead to compromise                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-56433                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ TEMP-0628843-DBAD28 │          │              │                         │                  │ [more related to CVE-2005-4890]                              │
│                    │                     │          │              │                         │                  │ https://security-tracker.debian.org/tracker/TEMP-0628843-DB- │
│                    │                     │          │              │                         │                  │ AD28                                                         │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ mount              │ CVE-2022-0563       │          │              │ 2.38.1-5+deb12u3        │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
│                    │                     │          │              │                         │                  │ and chsh when compiled...                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ ncurses-base       │ CVE-2023-50495      │ MEDIUM   │              │ 6.4-4                   │                  │ ncurses: segmentation fault via _nc_wrap_entry()             │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-50495                   │
├────────────────────┤                     │          │              │                         ├──────────────────┤                                                              │
│ ncurses-bin        │                     │          │              │                         │                  │                                                              │
│                    │                     │          │              │                         │                  │                                                              │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ nginx              │ CVE-2024-7347       │          │              │ 1.27.4-1~bookworm       │                  │ nginx: specially crafted MP4 file may cause denial of        │
│                    │                     │          │              │                         │                  │ service                                                      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-7347                    │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2009-4487       │ LOW      │              │                         │                  │ nginx: Absent sanitation of escape sequences in web server   │
│                    │                     │          │              │                         │                  │ log                                                          │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2009-4487                    │
│                    ├─────────────────────┤          ├──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2013-0337       │          │ will_not_fix │                         │                  │ The default configuration of nginx, possibly 1.3.13 and      │
│                    │                     │          │              │                         │                  │ earlier, uses ......                                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2013-0337                    │
│                    ├─────────────────────┤          ├──────────────┤                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-44487      │          │ affected     │                         │                  │ HTTP/2: Multiple HTTP/2 enabled web servers are vulnerable   │
│                    │                     │          │              │                         │                  │ to a DDoS attack...                                          │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-44487                   │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ openssl            │ CVE-2024-13176      │ MEDIUM   │              │ 3.0.15-1~deb12u1        │                  │ openssl: Timing side-channel in ECDSA signature computation  │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-13176                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ passwd             │ CVE-2023-4641       │          │              │ 1:4.13+dfsg1-1+b1       │                  │ shadow-utils: possible password leak during passwd(1) change │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-4641                    │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2007-5686       │ LOW      │              │                         │                  │ initscripts in rPath Linux 1 sets insecure permissions for   │
│                    │                     │          │              │                         │                  │ the /var/lo ......                                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2007-5686                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-29383      │          │              │                         │                  │ shadow: Improper input validation in shadow-utils package    │
│                    │                     │          │              │                         │                  │ utility chfn                                                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-29383                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2024-56433      │          │              │                         │                  │ shadow-utils: Default subordinate ID configuration in        │
│                    │                     │          │              │                         │                  │ /etc/login.defs could lead to compromise                     │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2024-56433                   │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ TEMP-0628843-DBAD28 │          │              │                         │                  │ [more related to CVE-2005-4890]                              │
│                    │                     │          │              │                         │                  │ https://security-tracker.debian.org/tracker/TEMP-0628843-DB- │
│                    │                     │          │              │                         │                  │ AD28                                                         │
├────────────────────┼─────────────────────┼──────────┤              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ perl-base          │ CVE-2023-31484      │ HIGH     │              │ 5.36.0-7+deb12u1        │                  │ perl: CPAN.pm does not verify TLS certificates when          │
│                    │                     │          │              │                         │                  │ downloading distributions over HTTPS...                      │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31484                   │
│                    ├─────────────────────┼──────────┤              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2011-4116       │ LOW      │              │                         │                  │ perl: File:: Temp insecure temporary file handling           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2011-4116                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ CVE-2023-31486      │          │              │                         │                  │ http-tiny: insecure TLS cert default                         │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-31486                   │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ sysvinit-utils     │ TEMP-0517018-A83CE6 │          │              │ 3.06-4                  │                  │ [sysvinit: no-root option in expert installer exposes        │
│                    │                     │          │              │                         │                  │ locally exploitable security flaw]                           │
│                    │                     │          │              │                         │                  │ https://security-tracker.debian.org/tracker/TEMP-0517018-A8- │
│                    │                     │          │              │                         │                  │ 3CE6                                                         │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ tar                │ CVE-2005-2541       │          │              │ 1.34+dfsg-1.2+deb12u1   │                  │ tar: does not properly warn the user when extracting setuid  │
│                    │                     │          │              │                         │                  │ or setgid...                                                 │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2005-2541                    │
│                    ├─────────────────────┤          │              │                         ├──────────────────┼──────────────────────────────────────────────────────────────┤
│                    │ TEMP-0290435-0B57B5 │          │              │                         │                  │ [tar's rmt command may have undesired side effects]          │
│                    │                     │          │              │                         │                  │ https://security-tracker.debian.org/tracker/TEMP-0290435-0B- │
│                    │                     │          │              │                         │                  │ 57B5                                                         │
├────────────────────┼─────────────────────┤          │              ├─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ util-linux         │ CVE-2022-0563       │          │              │ 2.38.1-5+deb12u3        │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
│                    │                     │          │              │                         │                  │ and chsh when compiled...                                    │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
├────────────────────┤                     │          │              │                         ├──────────────────┤                                                              │
│ util-linux-extra   │                     │          │              │                         │                  │                                                              │
│                    │                     │          │              │                         │                  │                                                              │
│                    │                     │          │              │                         │                  │                                                              │
├────────────────────┼─────────────────────┼──────────┼──────────────┼─────────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
│ zlib1g             │ CVE-2023-45853      │ CRITICAL │ will_not_fix │ 1:1.2.13.dfsg-1         │                  │ zlib: integer overflow and resultant heap-based buffer       │
│                    │                     │          │              │                         │                  │ overflow in zipOpenNewFileInZip4_6                           │
│                    │                     │          │              │                         │                  │ https://avd.aquasec.com/nvd/cve-2023-45853                   │
└────────────────────┴─────────────────────┴──────────┴──────────────┴─────────────────────────┴──────────────────┴──────────────────────────────────────────────────────────────┘
```
