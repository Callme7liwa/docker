# 1. Créer un réseau bridge personnalisé avec des options spécifiques
docker network create \
  --driver bridge \
  --subnet 172.20.0.0/16 \
  --gateway 172.20.0.1 \
  --ip-range 172.20.10.0/24 \
  --label project=myapp \
  my-custom-network

# 2. Vérifier la création du réseau
docker network inspect my-custom-network

# 3. Créer des conteneurs en les attachant au réseau
docker run -d \
  --name web-app \
  --network my-custom-network \
  --ip 172.20.10.10 \
  nginx

docker run -d \
  --name db \
  --network my-custom-network \
  --ip 172.20.10.20 \
  mysql:8

# 4. Connecter un conteneur existant au réseau
docker network connect my-custom-network existing-container

# 5. Déconnecter un conteneur du réseau
docker network disconnect my-custom-network existing-container

# 6. Supprimer le réseau (nécessite de déconnecter tous les conteneurs d'abord)
docker network rm my-custom-network