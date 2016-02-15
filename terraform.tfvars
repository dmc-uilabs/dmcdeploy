
# the aws keys 
access_key = ""
secret_key = ""

# the region you wish to deploy to 
aws_region = "us-east-1"






# keys for the front end machine
key_name_front = "2016_02_15_10_22_15_alpha-2-15_1"
key_full_path_front = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_1"

# which comit to deploy on the front end machine
# if commit_front = 'hot' -- the latest available build will be selected
commit_front = "352beb61d4206de468124e6d2924271502528662"



# keys for the rest machine
key_name_rest = "2016_02_15_10_22_15_alpha-2-15_2"
key_full_path_rest = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_2"

# which comit to deploy on the rest machine
# if commit_rest = 'hot' -- the latest availble build will be selected
commit_rest = "3eefccc00ff2bb7e314a7891e65dba98baad5419"



# keys to the db machine
key_name_db = "2016_02_15_10_22_15_alpha-2-15_3"
key_full_path_db = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_3"

# Postgress credentials
PSQLUSER = "gforge"
PSQLPASS= "gforge"
PSQLDBNAME = "gforge"



# keys to the solr machine
key_name_solr = "2016_02_15_10_22_15_alpha-2-15_4"
key_full_path_solr = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_4"




# credentials for activeMQ
activeMqRootPass = "admin1"
activeMqUserPass = "user1"


stackPrefix = "prod-2-15-"
release = "hot"




# Server load balancers
restLb = "qar.opendmc.org"
serverURL = "beta.opendmc.org"

# server log level (production, development)
loglevel = "production"

# deploy stack with swagger
use_swagger = "1"
