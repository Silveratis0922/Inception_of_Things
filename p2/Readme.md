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
- **conf/deployment.yaml** : Contient les spécifications du déploiement des containers, avec les images Docker et les ressources allouées.
- **conf/service.yaml** : Crée un service pour exposer les pods du déploiement.
- **conf/ingress.yaml** : Crée un Ingress pour gérer l'accès externe au service via un URL.
- **conf/vars.yaml** : Contient les variables de configuration, telles que les noms des services et des images.

## 📄 Détails des fichiers

1️⃣ **Vagrantfile**  
Le fichier Vagrantfile définit la configuration des machines virtuelles qui seront utilisées pour héberger le cluster Kubernetes. Ce fichier spécifie la configuration de chaque machine (serveur K3s et agent K3s), les paramètres réseau, ainsi que les ressources (CPU, mémoire). 

Il inclut également les scripts nécessaires pour provisionner et configurer le cluster au démarrage des machines.

2️⃣ **conf/namespace.yaml**  
Le fichier namespace.yaml crée un namespace Kubernetes. Il est essentiel pour séparer les ressources d'un projet des autres projets dans le même cluster.

3️⃣ **conf/deployment.yaml**  
Ce fichier définit le déploiement des applications. Il contient la configuration pour déployer les containers Docker dans le cluster, avec des informations sur les réplicas, les images utilisées, ainsi que les ressources (CPU et mémoire).

4️⃣ **conf/service.yaml**  
Le fichier service.yaml définit un service Kubernetes qui permet d'exposer le déploiement aux autres ressources dans le cluster. Ce service peut également être configuré pour permettre l'accès externe, en fonction de la configuration d'Ingress.

5️⃣ **conf/ingress.yaml**  
Ce fichier crée un Ingress pour gérer l'accès externe au cluster via une URL. Il redirige les requêtes HTTP vers le service approprié, facilitant ainsi l'accès aux applications sans nécessiter de configuration manuelle des IPs et des ports.

6️⃣ **conf/vars.yaml**  
Le fichier vars.yaml contient les variables que tu peux ajuster selon tes besoins. Par exemple, les noms d'image Docker, les ressources allouées aux containers, et les configurations spécifiques du déploiement.

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

🎉 Ton cluster K3s avec l'application déployée est maintenant opérationnel !
