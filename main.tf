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


resource "aws_ecs_cluster" "flaskapp-cluster" {
  name = "flaskapp-cluster"
}

resource "aws_ecs_service" "flaskapp-ecs-service" {
  name            = "flask-app"
  cluster         = aws_ecs_cluster.flaskapp-cluster.id
  task_definition = aws_ecs_task_definition.flask-ecs-task-definition.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets           = ["subnet-b990f8df"]
    assign_public_ip  = true
  }

  desired_count = 1
}

resource "aws_ecs_task_definition" "flask-ecs-task-definition" {
  family                   = "flask-ecs-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::635776503252:role/ECS-task-execution-role"
  container_definitions    = <<EOF
[
  {
    "name": "myflask",
    "image": "635776503252.dkr.ecr.us-east-1.amazonaws.com/flask-demo:myflask",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}
