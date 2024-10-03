#target group for load balancer
resource "aws_lb_target_group" "asg-target-group" {
  name     = "asg-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    interval = 30
    path = "/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 5
  }
}

#creation of appliation load balancer, external
resource "aws_lb" "webpage-lb" {
  name               = "webpage-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

#listener on port 80 for traffic from cloudfront, forward to the target group (instances)
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.webpage-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg-target-group.arn
  }
}
