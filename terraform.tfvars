
# the aws keys
access_key = "access"
secret_key = "secret"

# the region you wish to deploy to
aws_region = "us-west-2"






# keys for the front end machine
key_name_front = "DMCDriver"
key_full_path_front = "/home/ec2-user/keys/DMCDriver.pem"

# which commit to deploy on the front end machine
# if commit_front = 'hot' -- the latest available build will be selected
commit_front = "hot"


# uncomment only if you wish to change the default location
#sp_cert_location = "/tmp"
#sp_key_location = "/tmp"


# keys for the rest machine
key_name_rest = "DMCDriver"
key_full_path_rest = "/home/ec2-user/keys/DMCDriver.pem"

# which comit to deploy on the rest machine
# if commit_rest = 'hot' -- the latest available build will be selected
commit_rest = "hot"



# keys to the db machine
key_name_db = "DMCDriver"
key_full_path_db = "/home/ec2-user/keys/DMCDriver.pem"

# Postgress credentials
PSQLUSER = "gforge"
PSQLPASS = "gforge"
PSQLDBNAME = "gforge"



# keys to the solr machine
key_name_solr = "DMCDriver"
key_full_path_solr = "/home/ec2-user/keys/DMCDriver.pem"


# keys to the dome machine
key_name_dome = "DMCDriver"
key_full_path_dome = "/home/ec2-user/keys/DMCDriver.pem"
commit_dome = "hot"
dome_server_user = ""
dome_server_pw = ""

# keys to the stackMon machine
key_name_stackMon = "DMCDriver"
key_full_path_stackMon = "/home/ec2-user/keys/DMCDriver.pem"


# credentials for activeMQ
key_name_activeMq = "DMCDriver"
key_full_path_activeMq = ""
commit_activeMq = ""
activeMqRootPass = ""
activeMqUserPass = ""


stackPrefix = "alex_2016_03_18_11_50_39"
release = ""




# Server load balancers
restLb = ""
serverURL = "ben-web.opendmc.org"

# server log level (production, development)
loglevel = "development"

# deploy stack with swagger
use_swagger = ""
