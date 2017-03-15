#!/bin/bash -v

source /etc/profile.d/dmc.sh


sudo su -c "sudo sed -i -e 's/peer/trust/g' /var/lib/pgsql/9.4/data/pg_hba.conf"
sudo su -c "sudo sed -i -e 's/ident/trust/g' /var/lib/pgsql/9.4/data/pg_hba.conf"
#sudo su -c "sudo sed -i -e 's/#listen_addresses = 'localhost'/listen_addresses='*'' /var/lib/pgsql/9.4/data/postgresql.conf"


# Add only authorized hosts i.e DOME, Rest Services preferably via  config file
#sudo su -c "echo \"host all gforge 10.0.0.0/8 trust\" >> /var/lib/pgsql/9.4/data/pg_hba.conf"
#sudo su -c "echo \"listen_addresses = '*'\" >> /var/lib/pgsql/9.4/data/postgresql.conf"
if [ $dmcenvmode == development ] ; then
  echo "System is set up for Develpment Mode."
  echo "host all gforge 0.0.0.0/0 md5" | sudo tee -a /var/lib/pgsql/9.4/data/pg_hba.conf
else
  echo "Value of dmcenvmode is $dmcenvmode "
fi
#

echo "host all gforge 10.0.0.0/8 trust" | sudo tee -a /var/lib/pgsql/9.4/data/pg_hba.conf
echo "listen_addresses = '*'" | sudo tee -a /var/lib/pgsql/9.4/data/postgresql.conf

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
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl restart postgresql-9.4.service
