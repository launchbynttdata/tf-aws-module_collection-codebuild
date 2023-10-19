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

output "project_name" {
  description = "Project name"
  value       = module.codebuild[*].project_name
}

output "project_id" {
  description = "Project ID"
  value       = module.codebuild[*].project_id
}

output "role_id" {
  description = "IAM Role ID"
  value       = module.codebuild[*].role_id
}

output "role_arn" {
  description = "IAM Role ARN"
  value       = module.codebuild[*].role_arn
}

output "pipeline_name" {
  value       = var.pipeline_name
  description = "Pipeline that created the codebuild."
}

output "buildspec" {
  description = "The buildspec the CodeBuild project is using."
  value       = module.codebuild[*].buildspec
}
