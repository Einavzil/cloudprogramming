resource "aws_launch_template" "webpageLT" {
    name = "webpage"
    image_id = "ami-066784287e358dad1"
    instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "webpageASG" {
    name = "webpageASG"

    desired_capacity = 2
    max_size = 4
    min_size = 2
    health_check_type = "EC2"

    
    launch_template {
      id = aws_launch_template.webpageLT.id
      version = "$Latest"
    }

    //List of the subnets where instances will be created
    vpc_zone_identifier = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

resource "aws_autoscaling_policy" "cpu_tracking" {
    name = "cpu-tracking-policy"
    autoscaling_group_name = aws_autoscaling_group.webpageASG.name
    policy_type = "TargetTrackingScaling"
    estimated_instance_warmup = 300
    
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 75.0
    }
}