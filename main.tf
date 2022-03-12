provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "flask-demo" {
  name                 = "flask-demo"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.flask-demo.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}

