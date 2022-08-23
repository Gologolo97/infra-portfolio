variable "vpc_cidr" { type = string }

variable "user_name" { type = string }

variable "sub_cidr_public" { type = list(any) }

variable "sub_cidr_private" { type = list(any) }

variable "availabilty_zone" { type = list(any) }