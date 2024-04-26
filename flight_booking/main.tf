terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "djangoapp_docker_terraform"
  }
}

# Defining variables
variable "app_name" {
  description = "Flight Booking application using django and redis"
  type        = string
}

variable "docker_image" {
  description = "URI of the Docker image for the Django application"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ECS cluster will deployed"
  type        = string
}

variable "subnets" {
  description = "List of subnet ids where the ECS tasks will be deployed"
  type        = list(string)
}

# Create an ECS cluster
resource "aws_ecs_cluster" "django_cluster" {
  name = "${var.app_name}-cluster"
}

# Define a task definition for ECS
resource "aws_ecs_task_definition" "django_task" {
  family                   = "${var.app_name}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name      = "django-container"
      image     = var.docker_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}

# Create IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach policy to ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create a security group for the ECS service
resource "aws_security_group" "ecs_service_sg" {
  name   = "${var.app_name}-ecs-service-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-ecs-service-sg"
  }
}

# Create an ECS service to run the task
resource "aws_ecs_service" "django_service" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.django_cluster.id
  task_definition = aws_ecs_task_definition.django_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }
}