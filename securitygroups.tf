resource "aws_security_group" "template_security_group" {
  name        = "template_security_group"
  description = "security group attached to the launch template"
  vpc_id      = aws_vpc.vpc.id
    
}

resource "aws_security_group" "lb_security_group" {
  name        = "lb_security_group"
  description = "security group attached to the lb"
  vpc_id      = aws_vpc.vpc.id
    
}

resource "aws_security_group_rule" "template_allow_from_lb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.template_security_group.id
  source_security_group_id = aws_security_group.lb_security_group.id

}

resource "aws_security_group_rule" "lb_allow_to_template" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb_security_group.id
  source_security_group_id = aws_security_group.template_security_group.id

}

#this rule is to enable pulling the github repository during startup
resource "aws_security_group_rule" "template_allow_to_everywhere" {
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.template_security_group.id
    cidr_blocks = ["0.0.0.0/0"]
}

#this rule to allow the lb to recieve from anywhere
resource "aws_security_group_rule" "lb_allow_from_anywhere" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.lb_security_group.id
    cidr_blocks = ["0.0.0.0/0"]
}

