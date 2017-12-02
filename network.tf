provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "${var.namespace}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

data "aws_route_table" "selected" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "route_gw" {
  route_table_id         = "${data.aws_route_table.selected.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_subnet" "2a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr_block, 8, 1)}"
  availability_zone = "us-west-2a"

  tags {
    Name = "${var.namespace}"
  }
}

resource "aws_subnet" "2b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr_block, 8, 2)}"
  availability_zone = "us-west-2b"

  tags {
    Name = "${var.namespace}"
  }
}

# data "aws_route_table" "selected_2b" {
#   subnet_id = "${aws_subnet.2b.id}"
# }

# resource "aws_route" "route_2b" {
#   route_table_id            = "${data.aws_route_table.selected_2b.id}"
#   destination_cidr_block    = "0.0.0.0/0"
#   vpc_peering_connection_id = "${aws_internet_gateway.gw.id}"
# }

resource "aws_subnet" "2c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr_block, 8, 3)}"
  availability_zone = "us-west-2c"

  tags {
    Name = "${var.namespace}"
  }
}

# data "aws_route_table" "selected_2c" {
#   subnet_id = "${aws_subnet.2c.id}"
# }


# resource "aws_route" "route_2c" {
#   route_table_id            = "${data.aws_route_table.selected_2c.id}"
#   destination_cidr_block    = "0.0.0.0/0"
#   vpc_peering_connection_id = "${aws_internet_gateway.gw.id}"
# }

