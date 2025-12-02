source_bucket_name           = "sample-source-bucket"
destination_bucket_name      = "sample-destination-bucket"
source_region                = "ap-southeast-1"
destination_region           = "us-east-1"
use_new_kms_key              = true
existing_source_kms_key      = "arn:aws:kms:us-east-1:089590376474:key/mrk-54a2ca302abf459d830f90dbd044054f"
existing_destination_kms_key = "arn:aws:kms:ap-southeast-1:528915018472:key/449765a2-4a82-4c7e-b6e1-695b3a73fe32"