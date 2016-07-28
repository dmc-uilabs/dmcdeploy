
# the aws keys
access_key = ""
secret_key = ""

# the region you wish to deploy to
aws_region = ""






# keys for the front end machine
key_name_front = ""
key_full_path_front = ""

# which commit to deploy on the front end machine
# if commit_front = '' -- the latest available build will be selected
commit_front = ""


#location of temp bucket
AWS_UPLOAD_BUCKET = ""


#aws credentials for temp bucket
AWS_UPLOAD_KEY = ""
AWS_UPLOAD_SEC = ""

#aws temp bucket region
AWS_UPLOAD_REGION = ""

# uncomment only if you wish to change the default location
#sp_cert_location = "/tmp"
#sp_key_location = "/tmp"


# keys for the rest machine
key_name_rest = ""
key_full_path_rest = ""

# which comit to deploy on the rest machine
# if commit_rest = '' -- the latest available build will be selected
commit_rest = ""



# keys to the db machine
key_name_db = ""
key_full_path_db = ""

# Postgress credentials
PSQLUSER = ""
PSQLPASS = ""
PSQLDBNAME = ""



# keys to the solr machine
key_name_solr = ""
key_full_path_solr = ""
solrDbPort = ""

# keys to the dome machine
key_name_dome = ""
key_full_path_dome = ""
commit_dome = ""
dome_server_user = ""
dome_server_pw = ""

# keys to the stackMon machine
key_name_stackMon = ""
key_full_path_stackMon = ""
commit_stackMon = ""

# credentials for activeMQ
key_name_activeMq = ""
key_full_path_activeMq = ""
commit_activeMq = ""
activeMqRootPass = ""
activeMqUserPass = ""
ActiveMQ_Port = ""
ActiveMQ_User = ""
ActiveMQ_Password = ""


# credentials for validate
key_name_validate = ""
key_full_path_validate = ""
commit_validate = ""


stackPrefix = ""
release = ""

#s3 buckets for uploads
S3SourceBucket = ""
S3DestBucket = ""
AWS_UPLOAD_BUCKET = ""
AWS_UPLOAD_BUCKET_FINAL = ""
AWS_UPLOAD_KEY = ""
AWS_UPLOAD_SEC = ""
AWS_UPLOAD_REGION = ""





# Server load balancers
restLb = ""
serverURL = ""

# server log level (production, development)
loglevel = ""

# deploy stack with swagger
use_swagger = ""
