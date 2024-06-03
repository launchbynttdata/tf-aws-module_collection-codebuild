# Replace the <> with the actual values

naming_prefix   = "git-demo"
source_type     = "GITHUB"
artifact_type   = "NO_ARTIFACTS"
source_location = "<github_repo_url>"
name            = "deploy"
buildspec       = "buildspec.yml"
codebuild_iam   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SecretAccess",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "<github_token_arn>"
        }
    ]
}
EOF

enable_github_authentication = true
create_webhooks              = true
github_token                 = "<github_token_arn>"
github_token_type            = "SECRETS_MANAGER"
webhook_filters = {
  EVENT    = "PULL_REQUEST_CREATED,PULL_REQUEST_UPDATED"
  BASE_REF = "main"
}
