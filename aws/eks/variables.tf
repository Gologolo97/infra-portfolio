variable "vpc_cidr" { default = "10.0.0.0/16" }

variable "user_name" { default = "golo-portfolio" }

variable "sub_cidr_public" {
  type    = list(any)
  default = ["10.0.0.0/20", "10.0.32.0/20"]
}

variable "sub_cidr_private" {
  type    = list(any)
  default = ["10.0.64.0/20", "10.0.96.0/20"]
}

variable "availability_zone" {
  type    = list(any)
  default = ["us-east-2a", "us-east-2b"]
}