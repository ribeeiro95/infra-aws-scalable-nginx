variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
  default = "sa-east-1"
}

variable "key_name" {}

variable "instance_count" {
  default = 2
}

variable "subnet_ids" {
  type    = list(string)
  default = [
    "subnet-0236e15e21bbd4bfc", # Subnet sa-east-1a
    "subnet-0304e0c88cb27a491", # Subnet sa-east-1b
    "subnet-0c8d94279fe87e8e7"  # Subnet sa-east-1c
  ]
}
