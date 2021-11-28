{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":[
        "s3:ListBucket"
      ],
      "Resource":[
        "arn:aws:s3:::${s3_bucket_name}"
      ]
    },
    {
      "Effect":"Allow",
      "Action":[
        "s3:GetObject"
      ],
      "Resource":[
        "arn:aws:s3:::${s3_bucket_name}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
