# NOT WORKING
apt-get update
apt-get install postgresql pg-dev
vim /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart
rake db:reset db:migrate
rvmsudo rails server -p 8080 -b 0.0.0.0