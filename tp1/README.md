# TP 1 : Docker goes BRRRRRRRR

## Partie 1 :

### 🌞 Instalation de Docker sur Ubuntu

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
