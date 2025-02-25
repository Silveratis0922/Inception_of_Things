# 📌 P2 : Déploiement d'Applications avec K3s

## 🚀 Prérequis
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/) (7.0.18 en fonction de la box utilisée)

## 📂 Structure du projet

```
/
├── Vagrantfile
├── conf/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── vars.yaml
├── scripts/
│   ├── server.sh
└── README.md
```

**Description des fichiers** :
- **Vagrantfile** : Définit la configuration de la machine virtuelle.
- **conf/namespace.yaml** : Déclare le namespace dans lequel les ressources seront déployées.
- **conf/deployment.yaml** : Contient les spécifications du déploiement des containers, avec les images et les ressources allouées.
- **conf/service.yaml** : Crée un service pour exposer les pods du déploiement.
- **conf/ingress.yaml** : Crée un Ingress pour gérer l'accès externe au service via un URL.
- **conf/vars.yaml** : Contient les variables de configuration, telles que les noms des services et des images.

## 📄 Détails des fichiers

1️⃣ **Vagrantfile**  
- Définit la configuration de la machine virtuelle utilisée pour héberger le cluster Kubernetes.  
- Configure le serveur K3s, les paramètres réseau et les ressources allouées (CPU, mémoire).  
- Inclut les scripts nécessaires pour provisionner et configurer le serveur au démarrage.   

### 2️⃣ **conf/namespace.yaml**  
- Définit un **namespace Kubernetes**.  
- Permet de séparer les ressources d’un projet des autres projets dans le même cluster.  
- Facilite l’organisation et l’isolation des ressources au sein du cluster.  

### 3️⃣ **conf/deployment.yaml**  
- Définit le déploiement des applications dans Kubernetes.   
- Spécifie le **nombre de réplicas** pour assurer la disponibilité et la scalabilité.  
- Détermine les **ressources allouées** aux containers (CPU et mémoire).  

### 4️⃣ **conf/service.yaml**  
- Définit un **service Kubernetes** qui expose les applications au sein du cluster.  
- Permet la communication entre les pods et d’autres ressources du cluster.   

### 5️⃣ **conf/ingress.yaml**  
- Crée un **Ingress** pour gérer l’accès externe au cluster via une URL.  
- Redirige les requêtes HTTP vers le service approprié.  
- Permet un accès simplifié aux applications sans configurer manuellement les IPs et ports.  

### 6️⃣ **conf/vars.yaml**  
- Contient des **variables de configuration** ajustables selon les besoins. 
- Permet d’adapter le déploiement aux exigences spécifiques du projet.  

### 7️⃣ **scripts/server.sh**  
- Exécute les commandes d’installation et de configuration du serveur Kubernetes (K3s).  
- Installe les paquets nécessaires : `curl`, `vim`, `net-tools`.  
- Configure l’alias `k` pour `kubectl` afin de faciliter son utilisation.  
- Installe K3s en mode serveur avec une configuration spécifique (`flannel-iface`, `node-ip`).  
- Génère un **token d’authentification** permettant aux agents de rejoindre le cluster.  
- Ajoute des entrées dans `/etc/hosts` pour permettre la résolution des noms de domaine des applications.  
- Applique les fichiers de configuration Kubernetes (`namespace.yaml`, `deployment.yaml`, `service.yaml`, `ingress.yaml`).  

## ⚙️ Installation

1️⃣ **Cloner le dépôt**

```sh
git clone <URL_DU_REPO>
cd <NOM_DU_REPO>
```

2️⃣ **Lancer Vagrant**

```sh
vagrant up
```

Cela va créer et démarrer deux machines virtuelles (serveur et agent).

3️⃣ **Accéder au serveur K3s**  

```sh
vagrant ssh <NOM_DE_LA_MACHINE>
```


## Commandes supplémentaires

🔹 **Vérifier l'état des ressources**

```sh
kubectl get all
```

Cela te permet de voir si les pods sont correctement déployés et si les services sont exposés.

🔹 **Arrêter les machines**  
```sh
vagrant halt
```

🔹 **Redémarrer les machines**  
```sh
vagrant up
```

🔹 **Supprimer les machines**  
```sh
vagrant destroy -f
```
