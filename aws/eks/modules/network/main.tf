resource "aws_vpc" "golo-port" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.prefix
  }
}

resource "aws_subnet" "golo-sub" {
  vpc_id            = aws_vpc.golo-terra-vpc.id
  count             = length(var.sub_cidr)
  cidr_block        = var.sub_cidr[count.index]
  availability_zone = var.availabilty_zone[count.index]

  tags = {
    Name = "${var.prefix}-${count.index + 1}"
  }
}
