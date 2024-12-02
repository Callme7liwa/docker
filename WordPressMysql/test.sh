# Voir les logs WordPress
docker-compose logs wordpress

# Voir les logs MySQL
docker-compose logs db

docker-compose ps

# Se connecter au conteneur MySQL
docker-compose exec db mysql -u wordpress -pwordpresspass

# Dans MySQL, vérifier la base de données
SHOW DATABASES;
USE wordpress;
SHOW TABLES;