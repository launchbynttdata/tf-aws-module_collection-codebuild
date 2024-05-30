
extra_permissions = ["s3:*"]
codebuild_projects = [
  {
    name          = "plan"
    buildspec     = "buildspec.yml"
    source_type   = "S3"
    codebuild_iam = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sts:AssumeRole"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
}
EOF
  },
  {
    name          = "deploy"
    buildspec     = "buildspec.yml"
    source_type   = "S3"
    codebuild_iam = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sts:AssumeRole"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
}
EOF
  }
]
