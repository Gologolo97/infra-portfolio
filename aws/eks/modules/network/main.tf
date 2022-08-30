resource "aws_vpc" "golo-portfolio" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.user_name
  }
}

resource "aws_internet_gateway" "golo-portfolio" {
  vpc_id = aws_vpc.golo-portfolio.id

  tags = {
    Name = "${var.user_name}"
  }
}



resource "aws_subnet" "golo-public" {
  vpc_id                  = aws_vpc.golo-portfolio.id
  count                   = 2
  cidr_block              = var.sub_cidr_public[count.index]
  availability_zone       = var.availabilty_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                        = "${var.user_name}-${count.index + 1}-public"
    "kubernetes.io/cluster/golo-portfolio" = "owned"
    "kubernetes.io/role/elb"    = "1"
  }
}

resource "aws_subnet" "golo-private" {
  vpc_id            = aws_vpc.golo-portfolio.id
  count             = 2
  cidr_block        = var.sub_cidr_private[count.index]
  availability_zone = var.availabilty_zone[count.index]

  tags = {
    Name                                   = "${var.user_name}-${count.index + 1}-private"
    "kubernetes.io/cluster/golo-portfolio" = "owned"
    "kubernetes.io/role/internal-elb"      = "1"
  }
}

resource "aws_eip" "golo-portfolio" {
  count = 2
  depends_on = [
    aws_internet_gateway.golo-portfolio
  ]

  tags = {
    "Name" = "${var.user_name}-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "golo-portfolio" {
  count         = 2
  allocation_id = aws_eip.golo-portfolio[count.index].id

  subnet_id = aws_subnet.golo-public[count.index].id

  tags = {
    "Name" = "${var.user_name}-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.golo-portfolio.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.golo-portfolio.id
  }

  tags = {
    Name = "${var.user_name}-public"
  }
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.golo-portfolio.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.golo-portfolio[count.index].id
  }

  tags = {
    Name = "${var.user_name}-${count.index + 1}-private"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.golo-public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.golo-private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

