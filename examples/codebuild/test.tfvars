
logical_product_family  = "terratest"
logical_product_service = "codebuild"
extra_permissions       = ["s3:*"]
codebuild_projects = [
  {
    name          = "plan"
    description   = "Terraform Plan"
    buildspec     = "buildspec.yml"
    artifact_type = "NO_ARTIFACTS"
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
    description   = "Terraform Deploy"
    buildspec     = "buildspec.yml"
    artifact_type = "NO_ARTIFACTS"
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
