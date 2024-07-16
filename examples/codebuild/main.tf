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

module "s3_source_bucket" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/s3_bucket/aws"
  version = "~> 1.0"

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service

  use_default_server_side_encryption = true

  enable_versioning = true
}

resource "aws_s3_object" "dummy_source_object" {
  bucket = module.s3_source_bucket.id
  key    = "dummysource.zip"
  source = "dummysource.zip"
}

module "codebuild" {
  source = "../.."

  codebuild_projects      = var.codebuild_projects
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  environment             = var.environment
  environment_number      = var.environment_number
  source_type             = "S3"
  source_location         = "${module.s3_source_bucket.id}/${aws_s3_object.dummy_source_object.key}"
  resource_number         = var.resource_number
  resource_names_map      = var.resource_names_map
  extra_permissions       = var.extra_permissions

  tags = var.tags
}
