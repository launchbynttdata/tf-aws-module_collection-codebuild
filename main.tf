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
  source = "git::https://github.com/launchbynttdata/terraform-aws-codebuild?ref=1.0.0"
  count  = length(var.codebuild_projects) > 1 ? length(var.codebuild_projects) : 1

  project_name = replace(module.resource_names["codebuild"].standard, local.naming_prefix, "${local.naming_prefix}_${try(var.codebuild_projects[count.index].name, var.name)}")
  description  = var.description

  artifact_location  = try(var.codebuild_projects[count.index].artifact_location, var.artifact_location)
  artifact_type      = try(var.codebuild_projects[count.index].artifact_type, var.artifact_type)
  build_image        = try(var.codebuild_projects[count.index].build_image, var.build_image)
  build_compute_type = try(var.codebuild_projects[count.index].build_compute_type, var.build_compute_type)
  build_timeout      = try(var.codebuild_projects[count.index].build_timeout, var.build_timeout)
  build_type         = try(var.codebuild_projects[count.index].build_type, var.build_type)
  buildspec          = try(file("./${var.codebuild_projects[count.index].buildspec}"), null)
  encryption_enabled = try(var.codebuild_projects[count.index].encryption_enabled, var.encryption_enabled)
  encryption_key     = try(var.codebuild_projects[count.index].encryption_key, var.encryption_key)
  extra_permissions  = try(var.codebuild_projects[count.index].extra_permissions, var.extra_permissions)
  privileged_mode    = try(var.codebuild_projects[count.index].privileged_mode, var.privileged_mode)
  logs_config        = try(var.codebuild_projects[count.index].logs_config, var.logs_config)
  source_location    = try(var.codebuild_projects[count.index].source_location, var.source_location)
  source_type        = try(var.codebuild_projects[count.index].source_type, var.source_type)
  secondary_sources  = try(var.codebuild_projects[count.index].secondary_sources, var.secondary_sources)
  codebuild_iam      = try(var.codebuild_projects[count.index].codebuild_iam, var.codebuild_iam)

  build_image_pull_credentials_type = try(var.codebuild_projects[count.index].build_image_pull_credentials_type, var.build_image_pull_credentials_type)
  environment_variables             = try(var.codebuild_projects[count.index].environment_variables, var.environment_variables)

  # Will authenticate with Github by using variable github_token
  enable_github_authentication = try(var.codebuild_projects[count.index].enable_github_authentication, var.enable_github_authentication)
  create_webhooks              = try(var.codebuild_projects[count.index].create_webhooks, var.create_webhooks)
  # If set, this will automatically create an environment variable by name GITHUB_TOKEN
  github_token       = try(var.codebuild_projects[count.index].github_token, var.github_token)
  github_token_type  = try(var.codebuild_projects[count.index].github_token_type, var.github_token_type)
  webhook_filters    = try(var.codebuild_projects[count.index].webhook_filters, var.webhook_filters)
  webhook_build_type = try(var.codebuild_projects[count.index].webhook_build_type, var.webhook_build_type)

  tags = merge(local.tags, { resource_name = replace(module.resource_names["codebuild"].standard, local.naming_prefix, "${local.naming_prefix}_${try(var.codebuild_projects[count.index].name, var.name)}") })
}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = join("", split("-", var.region))
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  instance_resource       = var.resource_number
  maximum_length          = each.value.max_length
}
