# Litebox Vagrant VM
litebox is a vagrant configuration for rapidly instantiating web-development servers. This configuration is very insecure by default, to facilitate as much open access as possible.

This Vagrantfile is built from a basis Vagrant box, with all software coming in from official software repositories. It contains the essentials, attempting to strike a fine balance between cruft and barrenness.

### Software
- Ubuntu
- Lighttpd
- MySQL
- PHP
- xdebug
- webgrind
- memcached
- redis
- ajenti

### Usage:
Note that all vagrant commands must be run from the same directory as this Vagrantfile.
##### Start the server:
```sh
host> cd /path/to/my/VagrantFile
host> vagrant up 
```
##### Connect via SSH:
```sh
vagrant ssh
```
##### Stop the server:
```sh
vagrant halt
```
##### Connect to mysql from host
```sh
mysql -uvagrant -pvagrant --host=127.0.0.1 --port=3306
```
### Passwords
##### mysql
- root: vagrant 
- user: vagrant
- password: vagrant
- default_db: vagrant

#### ajenti admin panel
```sh
https://192.168.33.10:8000
```
- user: root
- password: admin

### Ports:
These can be modified within the Vagrantfile
- HTTP: 8080
- MySQL: 3306
- xdebug: 9000
- memcached: 11211
- ajenti 8000

### Using webgrind:
Generate a webgrind file:
```sh
http://192.168.33.10/mypage.php?XDEBUG_PROFILE=1
```
Then access webgrind via:
```sh
http://192.168.33.10/VagrantDeps/webgrind
```

### Using memcached:
You can verify the installation is working with netcat:
```sh
host> echo "stats settings" | nc 192.168.33.10 11211
```

### Using redis
```sh
vagrant> redis-cli
vagrant-redis> info
```
### Using ajenti
Make sure you are connecting via https
```sh
https://192.168.33.10:8000
user: root
password: admin
```