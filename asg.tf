resource "aws_launch_configuration" "lc" {
  name_prefix                 = "lc-${var.namespace}"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${aws_security_group.asg_member.id}"]
  associate_public_ip_address = true

  key_name = "${var.key_name}"

  user_data = "${data.template_cloudinit_config.config.rendered}"

  iam_instance_profile = "${aws_iam_instance_profile.cluster.name}"
  enable_monitoring    = false

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "8"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "$asg-${var.namespace}"

  min_size             = "${var.cluster_size}"
  max_size             = "${var.cluster_size}"
  desired_capacity     = "${var.cluster_size}"
  vpc_zone_identifier  = ["${aws_subnet.2a.id}", "${aws_subnet.2b.id}", "${aws_subnet.2c.id}"]
  launch_configuration = "${aws_launch_configuration.lc.name}"

  health_check_grace_period = 5
  default_cooldown          = 5
  health_check_type         = "EC2"

  tag {
    key                 = "Name"
    value               = "cluster-${var.namespace}"
    propagate_at_launch = true
  }

  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]

  tag {
    key                 = "Cluster"
    value               = "${var.namespace}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
