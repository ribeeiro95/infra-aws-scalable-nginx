output "alb_dns_name" {
  value = aws_lb.nginx_alb.dns_name
}

output "instance_ips" {
  value = [for instance in aws_instance.nginx_server : instance.public_ip]
}
