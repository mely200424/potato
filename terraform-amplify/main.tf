provider "aws" {
  region = "us-east-1"
}

variable "github_token" {
  description = "token de githun"
  type        = string
  sensitive   = true
}

resource "aws_amplify_app" "hola-mundo" {
  name       = "potato"
  repository = "https://github.com/mely200424/potato"
  oauth_token = var.github_token

  build_spec = <<-EOT
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - npm ci
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: dist
    files:
      - '**/*'
  cache:
    paths:
      - node_modules/**/*
EOT
}

resource "aws_amplify_branch" "main" {
  app_id = aws_amplify_app.hola-mundo.id
  branch_name = "main"
}

output "amplify_app_url" {
  value = aws_amplify_app.hola-mundo.default_domain
}