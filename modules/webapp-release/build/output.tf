output "codebuild_project_name" {
  value = aws_codebuild_project._.name
}

output "envs_sm_id" {
  value = aws_secretsmanager_secret._.id
}
