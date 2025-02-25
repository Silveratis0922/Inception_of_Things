# 📌 P1 : Déploiement de K3s avec Vagrant et VirtualBox

Ce projet permet de configurer automatiquement un cluster K3s avec un serveur et un agent en utilisant Vagrant et VirtualBox.

---

## 🚀 Prérequis

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/) (7.0.18 en fonction de la box utilisée)

---

## 📂 Structure du projet

```
/
├── Vagrantfile
├── conf/
│   ├── conf.yaml
├── scripts/
│   ├── server.sh
│   ├── agent.sh
```

### Description des fichiers :

- **Vagrantfile** : Définit la configuration des machines virtuelles.
- **conf/conf.yaml** : Contient les variables de configuration (IP, mémoire, etc.).
- **scripts/server.sh :** Installe K3s en mode serveur (control plane) sur la machine serveur, permettant l'utilisation de kubectl et générant un token d'accès pour les agents.
- **scripts/agent.sh :** Installe K3s en mode agent sur la machine agent, qui rejoint le cluster à l'aide du token.

---

## 📄 Détails des fichiers

### 1️⃣ Vagrantfile

Le fichier **Vagrantfile** est essentiel pour définir la configuration des machines virtuelles à créer avec Vagrant. Il inclut des informations sur :

- **Les machines virtuelles** : Il configure les deux VMs nécessaires pour ce projet : un serveur K3s et un agent K3s.
- **Les paramètres réseau** : Chaque VM reçoit une adresse IP statique pour faciliter la communication entre les nœuds.
- **Les ressources des VMs** : Vous pouvez ajuster la mémoire et le nombre de CPU alloués à chaque machine.
- **Provisioning** : Ce fichier spécifie l'exécution des scripts de configuration (comme server.sh pour le serveur et agent.sh pour l'agent).

Ce fichier est utilisé par Vagrant pour configurer et déployer les machines virtuelles automatiquement lors de l'exécution de `vagrant up`.

---

### 2️⃣ **conf/conf.yaml**

Les variables de configuration se trouvent dans `conf/conf.yaml`. Vous pouvez les modifier avant de lancer `vagrant up`.

Après modification, relancez :

```sh
vagrant reload --provision
```

---

### 3️⃣ **scripts/server.sh**

Le script **server.sh** est exécuté sur la machine serveur pour installer et configurer K3s, le serveur du cluster Kubernetes. Il contient les étapes suivantes :

1. **Installation de K3s en mode serveur** : Le script télécharge et installe K3s en mode serveur sur la machine, lui permettant d'agir comme le control plane du cluster Kubernetes et d'exécuter kubectl par défaut.
2. **Initialisation du serveur K3s** : Il configure K3s pour qu'il fonctionne comme le nœud maître du cluster.
3. **Génération du token** : Le script crée un fichier token dans le répertoire `token/`, nécessaire pour que les agents puissent rejoindre le cluster.

---

### 4️⃣ **scripts/agent.sh**

Le script **agent.sh** est exécuté sur la machine agent pour installer K3s et la connecter au serveur Kubernetes. Les étapes incluent :

1. **Installation de K3s en mode agent** : Le script télécharge et installe K3s en mode agent sur la machine agent, lui permettant de rejoindre le cluster mais sans kubectl par défaut.
2. **Rejoindre le serveur** : Le script utilise le fichier `node-token` généré par le serveur pour joindre ce dernier et s'ajouter comme nœud dans le cluster K3s.

---

## ⚙️ Installation

### 1️⃣ Cloner le dépôt

```sh
git clone <URL_DU_REPO>
cd <NOM_DU_REPO>
```

### 2️⃣ Lancer Vagrant

```sh
vagrant up
```

Cela va créer deux machines :

- **Un serveur** (`192.168.56.110`)
- **Un agent** (`192.168.56.111`)

### 3️⃣ Commandes

#### 🔹 Se connecter a une machine

```sh
vagrant ssh <NOM_DE_LA_MACHINE>
```

#### 🔹 Tester le cluster

```sh
sudo kubectl get nodes -o wide
```

Si tout fonctionne bien, les deux nœuds devraient apparaître avec le statut `Ready`.

#### 🔹 Arrêter les machines

```sh
vagrant halt
```

#### 🔹 Redémarrer les machines

```sh
vagrant up
```

#### 🔹 Supprimer les machines

```sh
vagrant destroy -f
```

---

🚀 **Votre cluster K3s est maintenant opérationnel !** 🎉
