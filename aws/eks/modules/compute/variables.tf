variable "user_name" { type = string }

variable "subnet_private" { type = list(any) }

variable "subnet_public" { type = list(any) }

variable "instance_types" { type = string }

variable "version" { type = string}

variable "desired_size" { type = number }

variable "max_size" { type = number }

variable "min_size" { type = number }