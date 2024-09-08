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
  region  = "us-east-1"
}



resource "aws_launch_template" "webpageLT" {
    name = "webpage"
    image_id = "ami-066784287e358dad1"
    instance_type = "t2.micro"

    //create VPCs to make sure it replicable, define the VPCs in ASG

    //volume definition
    ebs {
        volume_size = 8
        volume_type = gp3
        delete_on_termination = true
    }
}

resource "aws_autoscaling_group" "webpageASG" {
    name = "webpageASG"

    //add a list of subnet defined in the vpc file.

    desired_capacity = 2
    max_size = 4
    min_size = 2
    health_check_type = "EC2"

    launch_template {
        aws_launch_template.webpageLT.id
    }
}

