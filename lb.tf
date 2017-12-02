resource "aws_elb" "elb-external" {
  internal        = false
  name            = "${var.namespace}-lb"
  security_groups = ["${aws_security_group.elb-external-sg-member.id}"]
  subnets         = ["${aws_subnet.2a.id}", "${aws_subnet.2b.id}", "${aws_subnet.2c.id}"]

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # todo make perfomance tests
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "external load balancer"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// external traffic 
resource "aws_security_group" "elb-external-sg-member" {
  vpc_id      = "${aws_vpc.main.id}"
  name_prefix = "lb-member-ex-"

  tags {
    Name    = "balancer member (external)"
    Service = "lb"
  }
}

// Allow communication from elb to instances (external node)
resource "aws_security_group_rule" "lb-ext" {
  security_group_id        = "${aws_security_group.asg_member.id}"
  type                     = "ingress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.elb-external-sg-member.id}"
}

// Allow communication from all in 80
resource "aws_security_group_rule" "lb-from-all" {
  security_group_id = "${aws_security_group.elb-external-sg-member.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

// Allow external comunication from lb
resource "aws_security_group_rule" "all-outbound-ext" {
  security_group_id = "${aws_security_group.elb-external-sg-member.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_autoscaling_attachment" "lb-external-atach" {
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  elb                    = "${aws_elb.elb-external.id}"
}
