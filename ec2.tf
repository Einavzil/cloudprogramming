resource "aws_launch_template" "webpage_lt" {
    name = "webpage"
    image_id = "ami-066784287e358dad1"
    instance_type = "t2.micro"

    # a public ip should't be needed, but for cost purposes the instance needs an ip address to be able to reach internet
    # ideally, the instance would be placed in a private subnet (without ip address) and with a routetable that sends traffic through a NAT Gateway
    # However NAT Gateways cost money, so the workaround is to have the instance on the public subnet and assign a public ip to it
    network_interfaces {
        associate_public_ip_address = true
        security_groups = [aws_security_group.template_security_group.id]
    }
    user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y nodejs
    sudo yum install -y git
    cd /home/ec2-user
    git clone https://github.com/Einavzil/nodejs-hello-world.git
    cd nodejs-hello-world
    sudo node src/server.js
  EOF
  )
}

resource "aws_autoscaling_group" "webpage_asg" {
    name = "webpage_asg"
    desired_capacity = 2
    max_size = 4
    min_size = 2
    health_check_type = "EC2"
    
    launch_template {
      id = aws_launch_template.webpage_lt.id
      version = "$Latest"
    }

    
    //List of the subnets where instances will be created
    vpc_zone_identifier = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]

    target_group_arns    = [aws_lb_target_group.asg-target-group.arn]
}

resource "aws_autoscaling_policy" "cpu_tracking" {
    name = "cpu-tracking-policy"
    autoscaling_group_name = aws_autoscaling_group.webpage_asg.name
    policy_type = "TargetTrackingScaling"
    estimated_instance_warmup = 300
    
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 75.0
    }
}