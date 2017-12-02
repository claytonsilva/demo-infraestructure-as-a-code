resource "aws_security_group" "asg_member" {
  vpc_id      = "${aws_vpc.main.id}"
  name_prefix = "security-asg-${var.namespace}"

  tags {
    Name = "sg-asg-${var.namespace}"
  }
}

// Allow Consul communication from members
resource "aws_security_group_rule" "ssh" {
  security_group_id = "${aws_security_group.asg_member.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

// Allow external comunication from lb
resource "aws_security_group_rule" "all-outbound-int" {
  security_group_id = "${aws_security_group.asg_member.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}
