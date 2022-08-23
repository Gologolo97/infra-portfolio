output "vpc_id" {
  value = aws_vpc.golo-portfolio
}

output "subnet_private" {
  value = aws_subnet.golo-private
}

output "subnet_public" {
  value = aws_subnet.golo-public
}