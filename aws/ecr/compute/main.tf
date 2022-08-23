resource "aws_ecr_repository" "golo-ecr" {
  name = "${var.prefix}-portfolio"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  } 
}