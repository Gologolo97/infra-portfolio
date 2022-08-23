resource "aws_vpc" "golo-port" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.user_name
  }
}

