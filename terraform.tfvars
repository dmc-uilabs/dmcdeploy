
# the aws keys
access_key = ""
secret_key = ""

# the region you wish to deploy to
aws_region = ""






# keys for the front end machine
key_name_front = ""
key_full_path_front = ""

# which commit to deploy on the front end machine
# if commit_front = 'hot' -- the latest available build will be selected
commit_front = "hot"


# uncomment only if you wish to change the default location
#sp_cert_location = "/tmp"
#sp_key_location = "/tmp"


# keys for the rest machine
key_name_rest = ""
key_full_path_rest = ""

# which comit to deploy on the rest machine
# if commit_rest = 'hot' -- the latest available build will be selected
commit_rest = "hot"



# keys to the db machine
key_name_db = ""
key_full_path_db = ""

# Postgress credentials
PSQLUSER = "gforge"
PSQLPASS= "gforge"
PSQLDBNAME = "gforge"



# keys to the solr machine
key_name_solr = ""
key_full_path_solr = ""


# keys to the dome machine
key_name_dome = ""
key_full_path_dome = ""

# keys to the stackMon machine
key_name_stackMon = ""
key_full_path_stackMon = ""


# credentials for activeMQ
key_name_activeMq = ""
key_full_path_activeMq = ""
activeMqRootPass = "admin1"
activeMqUserPass = "user1"


stackPrefix = ""
release = "hot"




# Server load balancers
restLb = ""
serverURL = ""

# server log level (production, development)
loglevel = ""

# deploy stack with swagger
use_swagger = "1"
