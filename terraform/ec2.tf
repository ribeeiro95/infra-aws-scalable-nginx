resource "aws_instance" "nginx_server" {
  for_each               = toset(var.subnet_ids)
  ami                    = "ami-0ba39aef11896824a" # Amazon Linux 2023
  instance_type          = "t3.micro"
  subnet_id              = each.value
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "nginx-docker-${each.key}"
  }
}
