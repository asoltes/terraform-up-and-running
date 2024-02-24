variable "source_region" {
    type = string
    description = "Region where the resources will be deployed"
  
}

variable "destination_region" {
    type = string
    description = "A region where the resources will be deployed"
  
}


variable "source_bucket_name" {
  type = string
  description = "Source bucket where the file will be pulled"
}


variable "destination_bucket_name" {
    type = string
    description = "Destination or target bucket where the objects will be replicated"
}

variable "use_new_kms_key" {
    type = bool
    description = "Use New kms key "
  
}

variable "existing_source_kms_key" {
    type = string
    description = "Use existing key kms key of source bucket "
  
}

variable "existing_destination_kms_key" {
    type = string
    description = "Use existing key kms key of destination bucket "
  
}

variable "secret_key" {
    type = string
    description = "Use existing key kms key of destination bucket "
  
}

variable "access_key" {
    type = string
    description = "Use existing key kms key of destination bucket "
  
}

