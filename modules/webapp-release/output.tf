output "codebuild_project_name" {
  value = module.code_build_project.codebuild_project_name
}

output "codepipeline_project_name" {
  value = module.code_pipeline_project.codepipeline_project_name
}

output "envs_sm_id" {
  value = module.code_build_project.envs_sm_id
}
