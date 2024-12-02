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

docker network ls 

docker network inspect wordpressmysql_wp_network

----------------------------------------------------------------
# D'abord installer ping
docker-compose exec wordpress apt-get update
docker-compose exec wordpress apt-get install -y iputils-ping

# Puis tester
docker-compose exec wordpress ping db
----------------------------------------------------------------
# Tester la connexion avec wget
docker-compose exec wordpress wget db:3306 -T 1

# Tester si WordPress répond
docker-compose exec wordpress curl -I localhost:80
----------------------------------------------------------------
docker volume ls
docker volume inspect wordpressmysql_db_data
docker volume inspect wordpressmysql_wordpress_data
----------------------------------------------------------------
#Examiner les fichiers de logs dans les volumes :
# Pour MySQL
docker-compose exec db ls -l /var/lib/mysql/mysql-error.log
docker-compose exec db tail -f /var/lib/mysql/mysql-error.log

# Pour WordPress
docker-compose exec wordpress tail -f /var/www/html/wp-content/debug.log

# Voir tous les événements Docker en temps réel
docker events --filter 'type=volume'

# Voir les événements spécifiques à un volume
docker events --filter 'volume=wordpressmysql_wordpress_data'