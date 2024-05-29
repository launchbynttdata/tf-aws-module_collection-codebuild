// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "codebuild" {
  source = "../.."

  name                         = var.name
  logical_product_family       = var.logical_product_family
  logical_product_service      = var.logical_product_service
  source_type                  = var.source_type
  artifact_type                = var.artifact_type
  source_location              = var.source_location
  codebuild_iam                = var.codebuild_iam
  enable_github_authentication = var.enable_github_authentication
  create_webhooks              = var.create_webhooks
  github_token                 = var.github_token
  github_token_type            = var.github_token_type
  webhook_filters              = var.webhook_filters

  tags = var.tags
}
