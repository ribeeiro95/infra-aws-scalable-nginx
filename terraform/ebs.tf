variable "subnet_az_map" {
  type = map(string)
  default = {
    "subnet-0236e15e21bbd4bfc" = "sa-east-1a"
    "subnet-0304e0c88cb27a491" = "sa-east-1b"
    "subnet-0c8d94279fe87e8e7" = "sa-east-1c"
  }
}

resource "aws_ebs_volume" "nginx_data" {
  for_each          = toset(var.subnet_ids)
  availability_zone = var.subnet_az_map[each.key]
  size              = 5
  type              = "gp2"
}

resource "aws_volume_attachment" "nginx_data_attach" {
  for_each    = aws_instance.nginx_server
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.nginx_data[each.key].id
  instance_id = each.value.id
}
