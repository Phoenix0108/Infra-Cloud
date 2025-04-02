# TP 3 : Automatisation et gestion de conf

## Ansible first steps

### 1. Mise en place

#### A. Setup Azure

- `main.tf`

```tf
provider "azurerm" {
  features {}
  subscription_id = "no"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  count               = 2
  name                = "${var.prefix}-pip-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_network_security_group" "ssh" {
  name                = "ssh"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.ssh.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = 2
  name                = "node-${count.index + 1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "admin01"

  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  admin_ssh_key {
    username   = "admin01"
    public_key = file("C:/Users/yanis/.ssh/last.pub")
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

  custom_data = filebase64("${path.module}/cloud-init.txt")
}
```

- `variable.tf`

```tf
variable "prefix" {
  description = "da prefix"
  default = "T3-Ansible"
}
variable "location" {
  description = "da location"
  default = "West Europe"
}
```

- `cloud-init.txt`

```txt
#cloud-config
users:
  - name: admin01
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
    ssh-authorized-keys:
      - pub key
packages:
  - python3
  - ansible

```

## 2. (3 dans le doc) Création de nouveaux playbooks

### NGINX

- `nginx.yml`

```yml
- name: Deploy NGINX with SSL
  hosts: web
  become: true
  tasks:
    - name: Ensure no other APT processes are running
      shell: while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 1; done
      changed_when: false

    - name: Install NGINX
      apt:
        name: nginx
        state: present

    - name: Create SSL directories
      file:
        path: "{{ item }}"
        state: directory
        mode: "0755"
      with_items:
        - /etc/pki/tls/private
        - /etc/pki/tls/certs

    - name: Copy SSL Certificates from Local Machine
      copy:
        src: "{{ item.src }}"
        dest: "{{ item.dest }}"
        mode: "0644"
      with_items:
        - { src: "./nginx.key", dest: "/etc/pki/tls/private/nginx.key" }
        - { src: "./nginx.crt", dest: "/etc/pki/tls/certs/nginx.crt" }

    - name: Configure NGINX
      template:
        src: ./roles/nginx/templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf

    - name: Create Web Root Directory
      file:
        path: /var/www/tp3_site/
        state: directory

    - name: Create Index File
      copy:
        content: "<h1>Hello NGINX with SSL</h1>"
        dest: /var/www/tp3_site/index.html

    - name: Check NGINX Configuration
      command: nginx -t
      register: nginx_test
      ignore_errors: true

    - name: Restart NGINX
      service:
        name: nginx
        state: restarted
      when: nginx_test.rc == 0
```

- `hosts.ini`

```ini
[tp3]
172.201.43.182
20.160.212.251

[web]
20.160.212.251
```

- `curl`

```bash
$ curl -k https://20.160.212.251
<h1>Hello NGINX with SSL</h1>
```

## MySQL

- `mysql.yml`

```yml
- name: Install and configure MySQL
  hosts: db
  vars:
    ansible_python_interpreter: /usr/bin/python3
  become: true
  tasks:
    - name: Install MySQL Server
      apt:
        name: mysql-server
        state: present

    - name: Start and enable MySQL
      service:
        name: mysql
        state: started
        enabled: true

    - name: Install Python MySQL dependencies
      apt:
        name: python3-pymysql
        state: present

    - name: Create database
      mysql_db:
        name: tp3_db
        state: present
        login_user: root
        login_unix_socket: /var/run/mysqld/mysqld.sock

    - name: Create MySQL user
      mysql_user:
        name: tp3_user
        password: securepassword
        priv: "tp3_db.*:ALL"
        host: "%"
        state: present
        login_user: root
        login_unix_socket: /var/run/mysqld/mysqld.sock
```

- `host.ini`

```ini
[tp3]
172.201.43.182
20.160.212.251

[web]
20.160.212.251

[db]
172.201.43.182

```

## Range ta chambre (non)
