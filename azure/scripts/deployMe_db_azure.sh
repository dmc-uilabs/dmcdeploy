#!/bin/bash -v

source /etc/profile.d/dmc.sh

echo include_dir = 'dmcconf.d' | sudo tee -a /var/lib/pgsql/9.4/data/postgresql.conf

#I hate this I hate I hate I hate I hate
echo -e "local\tall\tall\t\t\ttrust" | sudo tee /var/lib/pgsql/9.4/data/pg_hba.conf
echo -e "host\tall\tall\t127.0.0.1/32\ttrust" | sudo tee -a /var/lib/pgsql/9.4/data/pg_hba.conf
echo -e "host\tall\tall\t::1/128\t\ttrust" | sudo tee -a /var/lib/pgsql/9.4/data/pg_hba.conf
echo -e "host\tall\tgforge\t10.0.0.0/8\ttrust" | sudo tee -a /var/lib/pgsql/9.4/data/pg_hba.conf
if [ $dmcenvmode == development ] ; then
  echo "System is set up for Develpment Mode."
  echo -e "host\tall\tgforge\t0.0.0.0/0\tmd5" | sudo tee -a /var/lib/pgsql/9.4/data/pg_hba.conf
else
  echo "Value of dmcenvmode is $dmcenvmode "
fi
#

echo "listen_addresses = '*'" | sudo tee -a /var/lib/pgsql/9.4/data/dmcconf.d/network.conf
echo "log_destination = 'csvlog'" | sudo tee -a /var/lib/pgsql/9.4/data/dmcconf.d/logging.conf

sudo systemctl start postgresql-9.4.service
sudo systemctl enable postgresql-9.4.service



cd /tmp
git clone https://github.com/dmc-uilabs/dmcdb.git

cd dmcdb

echo "Dropping $DB -- db"
sudo -u postgres psql -c "DROP DATABASE $DB"
echo "Create new DB $DB"
sudo -u postgres psql -c "CREATE ROLE $PSQLUSER NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN PASSWORD '$PSQLPASS';"
sudo -u postgres psql -c "CREATE DATABASE $DB WITH OWNER $PSQLUSER;"
echo "Inserting sample data"

# load sample data, including DMDII member organizations
./flyway migrate info -configFile=conf/core/flyway.conf -url=jdbc:postgresql://localhost:5432/$DB  -user=$PSQLUSER -password=$PSQLPASS
#Load sample database
./flyway migrate info -configFile=conf/data/flyway.conf -url=jdbc:postgresql://localhost:5432/$DB -user=$PSQLUSER -password=$PSQLPASS -locations=filesystem:./sql/data/dev2
cd /tmp
# rm -rf /tmp/dmcdb
sudo systemctl restart postgresql-9.4.service
