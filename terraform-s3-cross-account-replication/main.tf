resource "aws_s3_bucket" "source_bucket" {
  bucket = var.source_bucket_name
  
  tags = {
    Name        = "My Source Bucket"
    Environment = "Dev"
  }
}

resource "aws_iam_policy" "source_bucket_new_kms_key_policy" {
    count = var.use_new_kms_key ? 1 : 0
    name = "${var.source_bucket_name}-policy"
    policy = jsonencode(
        {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowTFstateAndLock",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:dynamodb:*:*:table/*tfstate*",
                "arn:aws:s3:::*tfstate*/*",
                "arn:aws:s3:::*tfstate*"
            ]
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetReplicationConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectRetention",
                "s3:GetObjectLegalHold"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.source_bucket_name}",  #SOURCE BUCKET
                "arn:aws:s3:::${var.source_bucket_name}/*" #SOURCE BUCKET
            ]
        },
        {
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags",
                "s3:GetObjectVersionTagging",
                "s3:ObjectOwnerOverrideToBucketOwner"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLikeIfExists": {
                    "s3:x-amz-server-side-encryption": [
                        "aws:kms",
                        "aws:kms:dsse",
                        "AES256"
                    ]
                }
            },
            "Resource": [
                "arn:aws:s3:::${var.destination_bucket_name}/*" #TARGET BUCKET
            ]
        },
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": "s3.${var.source_region}.amazonaws.com",
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::${var.source_bucket_name}/*"
                    ]
                }
            },
            "Resource": [
                "${aws_kms_key.source_bucket_kms_key[0].key_id}" #SOURCE KMS KEY
            ]
        },
        {
            "Action": [
                "kms:Encrypt"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": [
                        "s3.${var.destination_region}.amazonaws.com"
                    ],
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::${var.destination_bucket_name}/*"
                    ]
                }
            },
            "Resource": [
                "${aws_kms_key.destination_bucket_kms_key[0].key_id}"
            ]
        }
    ]}
    )
}

resource "aws_iam_policy" "source_bucket_existing_kms_key_policy" {
    count = var.use_new_kms_key ? 0 : 1
    name = "${var.source_bucket_name}-policy"
    policy = jsonencode(
        {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowTFstateAndLock",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:dynamodb:*:*:table/*tfstate*",
                "arn:aws:s3:::*tfstate*/*",
                "arn:aws:s3:::*tfstate*"
            ]
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetReplicationConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectRetention",
                "s3:GetObjectLegalHold"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.source_bucket_name}",  #SOURCE BUCKET
                "arn:aws:s3:::${var.source_bucket_name}/*" #SOURCE BUCKET
            ]
        },
        {
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags",
                "s3:GetObjectVersionTagging",
                "s3:ObjectOwnerOverrideToBucketOwner"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLikeIfExists": {
                    "s3:x-amz-server-side-encryption": [
                        "aws:kms",
                        "aws:kms:dsse",
                        "AES256"
                    ]
                }
            },
            "Resource": [
                "arn:aws:s3:::${var.destination_bucket_name}/*" #TARGET BUCKET
            ]
        },
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": "s3.${var.source_region}.amazonaws.com",
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::${var.source_bucket_name}/*"
                    ]
                }
            },
            "Resource": [
                "${var.existing_source_kms_key}" #SOURCE KMS KEY
            ]
        },
        {
            "Action": [
                "kms:Encrypt"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": [
                        "s3.${var.destination_region}.amazonaws.com"
                    ],
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::${var.destination_bucket_name}/*"
                    ]
                }
            },
            "Resource": [
                "${var.existing_destination_kms_key}"
            ]
        }
    ]}
    )
}


resource "aws_iam_role" "source_bucket_iam_role" {
    name = "${var.source_bucket_name}-iam-role"
    assume_role_policy = jsonencode(
        {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
    # count      = var.use_new_kms_key ? 1 : 0
    role       = aws_iam_role.source_bucket_iam_role.name
    policy_arn = var.use_new_kms_key ? aws_iam_policy.source_bucket_new_kms_key_policy[0].arn : var.existing_source_kms_key
}

resource "aws_kms_key" "source_bucket_kms_key" {
    count                   = var.use_new_kms_key ? 1 : 0
    description             = "${var.source_bucket_name} KMS Key"
    deletion_window_in_days = 7
    enable_key_rotation     = true
}


################################Destination Bucket Configurations##############################################

resource "aws_s3_bucket" "destination_bucket" {
  bucket = var.destination_bucket_name
  
  tags = {
    Name        = "My Destination bucket"
    Environment = "Dev"
  }
}

resource "aws_kms_key" "destination_bucket_kms_key" {
    count                   = var.use_new_kms_key ? 1 : 0
    description             = "${var.destination_bucket_name} KMS Key"
    deletion_window_in_days = 7
    enable_key_rotation     = true
    policy = jsonencode(
    {
    "Sid": "Enable cross account encrypt access for S3 Cross Region Replication",
    "Effect": "Allow",
    "Principal": {
        "AWS": [
        "arn:aws:iam::089590376474:root", #SOURCE BUCKET ACCOUNT NUMBER
        "arn:aws:iam::089590376474:role/markit-s3-cross-account-replication-role", #IAM ROLE OF SOURCE BUCKET
        "arn:aws:iam::528915018472:role/epic-demo-ec2-default-iam-role" #IAM ROLE OF EC2 INSTANCE DEMO2
        ]
    },
    "Action": [
        "kms:Encrypt"
    ],
    "Resource": "*"
    })
}