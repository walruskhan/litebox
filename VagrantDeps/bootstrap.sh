# Default MySQL credentials - feel free to modify
MYSQL_ROOT_PASSWORD=vagrant
MYSQL_DEFAULT_USER=vagrant
MYSQL_DEFAULT_PASSWORD=vagrant
MYSQL_DEFAULT_DATABASE=vagrant

# Point /var/www to the automatically mounted /vagrant directory
if ! [ -L /var/www ]; then
	rm -rf /var/www
	ln -fs /vagrant /var/www
fi

apt-get -y -qq update

# Install lighttpd
apt-get -y install lighttpd

# Install PHP
apt-get -y install php5-cgi php5-cli php5-intl php5-sqlite php5-mcrypt
lighttpd-enable-mod fastcgi
lighttpd-enable-mod fastcgi-php 
php5enmod mcrypt

# Enable error handling
cp /vagrant/VagrantDeps/configs/custom.ini /etc/php5/mods-available/custom.ini
php5enmod custom
touch /var/log/php_errors.log
chown www-data:www-data /var/log/php_errors.log 

# Install and configure xdebug and webgrind
apt-get -y install php5-xdebug graphviz
cp /vagrant/VagrantDeps/configs/xdebug.ini /etc/php5/mods-available/xdebug.ini
mkdir -p /tmp/cachegrind
chown www-data:www-data /tmp/cachegrind
# TODO: Clone webgrind repo, and configure webgrind/config.php

# Setup memcached
apt-get install -y memcached php5-memcached
sed -i 's/-l/#-l/' /etc/memcached.conf 
service memcached restart

# Setup redis
apt-get install -y redis-server php5-redis
service redis-server restart

# Install mysql
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

apt-get -y install mysql-server

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e"CREATE USER '$MYSQL_DEFAULT_USER'@'%' IDENTIFIED BY '$MYSQL_DEFAULT_PASSWORD'"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e"CREATE DATABASE $MYSQL_DEFAULT_DATABASE"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e"GRANT ALL ON $MYSQL_DEFAULT_DATABASE.* TO '$MYSQL_DEFAULT_USER'@'%'"
sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf # Listen for remote connections

service mysql restart
service lighttpd restart

# Install ajenti
wget -O- https://raw.github.com/ajenti/ajenti/1.x/scripts/install-ubuntu.sh | sudo sh
ufw allow 8000


echo " "
echo " "
echo " "
echo " "
echo " "
echo "-----------------"
echo "----- DONE! -----"
echo "-----------------"
echo "Server Info:"
echo "   Addresses: `hostname -I | awk '{ print $2}'`"
echo " "
echo "MySQL Credentials:"
echo "   user: root        password: $MYSQL_ROOT_PASSWORD"
echo "   user: $MYSQL_DEFAULT_USER     password: $MYSQL_DEFAULT_PASSWORD     database: $MYSQL_DEFAULT_DATABASE"
echo "        e.g. mysql -u$MYSQL_DEFAULT_USER -p$MYSQL_DEFAULT_PASSWORD $MYSQL_DEFAULT_DATABASE --host=`hostname -I | awk '{ print $2}'` --port=3306"
echo " "
echo "Ports:"
echo "   HTTP:   80"
echo "   SQL:    3306"
echo "   xdebug: 9000"
echo " "
echo "Thankyou for using litebox - the (mostly) bs-free vagrant LLMP stack"

#echo "zend_extension=`find /usr/bin -name xdebug.so`" >> /etc/php5/cgi/php.ini
#echo 'xdebug.default_enable=1' >> /etc/php5/cgi/php.ini
#echo 'xdebug.idekey="vagrant"' >> /etc/php5/cgi/php.ini
#echo 'xdebug.remote_enable=1' >> /etc/php5/cgi/php.ini
#echo 'xdebug.remote_autostart=0' >> /etc/php5/cgi/php.ini
#echo 'xdebug.remote_port=9000' >> /etc/php5/cgi/php.ini
#echo 'xdebug.remote_handler=dbgp' >> /etc/php5/cgi/php.ini
#echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' >> /etc/php5/cgi/php.ini
#echo 'xdebug.remote_host=10.0.2.2' >> /etc/php5/cgi/php.ini

#mkdir -p /var/log/xdebug
#chown www-data:www-data /var/log/xdebug
