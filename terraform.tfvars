
# the aws keys 
access_key = ""
secret_key = ""

# the region you wish to deploy to 
aws_region = "us-west-2"






# keys for the front end machine
key_name_front = "DMCDriver"
key_full_path_front = "~/Desktop/keys/DMCDriver.pem"

# which comit to deploy on the front end machine
# if commit_front = 'hot' -- the latest available build will be selected
commit_front = "352beb61d4206de468124e6d2924271502528662"



# keys for the rest machine
key_name_rest = "DMCDriver"
key_full_path_rest = "~/Desktop/keys/DMCDriver.pem"

# which comit to deploy on the rest machine
# if commit_rest = 'hot' -- the latest availble build will be selected
commit_rest = "3eefccc00ff2bb7e314a7891e65dba98baad5419"



# keys to the db machine
key_name_db = "DMCDriver"
key_full_path_db = "~/Desktop/keys/DMCDriver.pem"

# Postgress credentials
PSQLUSER = "gforge"
PSQLPASS= "gforge"
PSQLDBNAME = "gforge"



# keys to the solr machine
key_name_solr = "DMCDriver"
key_full_path_solr = "~/Desktop/keys/DMCDriver.pem"




# credentials for activeMQ
activeMqRootPass = "admin1"
activeMqUserPass = "user1"


stackPrefix = "alex-2-16-"
release = "hot"




# Server load balancers
restLb = "ben-rest.opendmc.org"
serverURL = "ben-web.opendmc.org"

# server log level (production, development)
loglevel = "production"

# deploy stack with swagger
use_swagger = "1"
