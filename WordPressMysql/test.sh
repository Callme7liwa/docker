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

------------------ NETWORKING ------------------------------

# Installer les outils réseau dans le conteneur WordPress
docker-compose exec wordpress apt-get update
docker-compose exec wordpress apt-get install -y iproute2 net-tools
# Vérifier les routes
docker-compose exec wordpress ip route
# Alternative avec route (qui est parfois déjà installé)
docker-compose exec wordpress route -n
# Voir les interfaces et leurs adresses
docker-compose exec wordpress ip addr
# Voir la configuration réseau complète
docker inspect wordpressmysql-wordpress-1 | grep -A 20 "NetworkSettings"

# regarder image.png

Explications du diagramme :

Niveau physique :

Votre PC a une carte réseau physique (NIC) qui se connecte à Internet
Cette carte a sa propre adresse IP (par exemple 192.168.1.x sur votre réseau local)


Niveau Docker :

Docker crée un bridge par défaut (docker0)
Votre réseau personnalisé (172.19.0.0/16) est créé avec son propre bridge


Conteneurs :

WordPress (172.19.0.3) est mappé au port 8090 de votre machine
MySQL (172.19.0.2) est accessible uniquement dans le réseau Docker
Les conteneurs communiquent entre eux via le bridge réseau Docker


Flux réseau :

Les requêtes externes arrivent sur le port 8090 de votre machine
Docker route ces requêtes vers le port 80 du conteneur WordPress
WordPress communique avec MySQL via le réseau interne Docker
Les requêtes Internet des conteneurs passent par le bridge Docker puis votre carte réseau

Cette architecture permet :

L'isolation des conteneurs
La communication sécurisée entre WordPress et MySQL
L'accès externe uniquement aux services exposés (port 8090)

---

qsq ca veut creer un bridge ?


Un bridge Docker est comme un commutateur (switch) virtuel qui :

Connecte les conteneurs entre eux :


Permet à WordPress de parler à MySQL
Donne des adresses IP aux conteneurs (comme 172.19.0.2, 172.19.0.3)
Isole ces conteneurs des autres réseaux


Fait le lien avec votre PC :


Agit comme une passerelle (gateway)
Permet aux conteneurs d'accéder à Internet
Permet à votre PC d'accéder aux conteneurs

# Liste tous les bridges Docker
docker network ls | grep bridge

# Voir les détails d'un bridge spécifique
docker network inspect bridge

PC (192.168.1.x) 
  └── Bridge Docker (172.19.0.1)
       ├── WordPress (172.19.0.3)
       └── MySQL (172.19.0.2)