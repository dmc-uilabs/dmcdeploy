
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
commit_front = "hot"


sp_cert_location = "~/Desktop/keys/sp-cert.pem"
sp_key_location = "~/Desktop/keys/sp-cert.pem"


# keys for the rest machine
key_name_rest = "2016_02_15_10_22_15_alpha-2-15_2"
key_full_path_rest = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_2"

# which comit to deploy on the rest machine
# if commit_rest = 'hot' -- the latest availble build will be selected
commit_rest = "ecb5bedeaf21f1f4e855bf0d2b59be199b087b3f"



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


# keys to the dome machine
key_name_dome = "2016_02_15_10_22_15_alpha-2-15_4"
key_full_path_dome = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_4"

# keys to the stackMon machine
key_name_stackMon = "2016_02_15_10_22_15_alpha-2-15_4"
key_full_path_stackMon = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_4"


# credentials for activeMQ
key_name_activeMq = "2016_02_15_10_22_15_alpha-2-15_4"
key_full_path_activeMq = "~/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_4"
activeMqRootPass = "admin1"
activeMqUserPass = "user1"


stackPrefix = "alex-2-16-"
release = "hot"




# Server load balancers
restLb = "ben-rest.opendmc.org"
serverURL = "beta.opendmc.org"

# server log level (production, development)
loglevel = "production"

# deploy stack with swagger
use_swagger = "1"
