# NOT WORKING
cd ~/RubymineProjects/testing-wrata
apt-get update
apt-get install postgresql-common postgresql libpq-dev nodejs
vim /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart
rake db:reset db:migrate
iptables -t nat -I PREROUTING -p tcp --dport 8080 -j REDIRECT --to-ports 3000
rails server -p 3000 -b 0.0.0.0