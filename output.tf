output "public_1_ip" {
  value = aws_instance.production_1_instance.public_ip
}

# output "public_2_ip" {
#   value = aws_instance.production_2_instance.public_ip
# }

# print the DNS of load balancer
# output "lb_dns_name" {
#   description = "The DNS name of the load balancer"
#   value       = aws_lb.application_loadbalancer.dns_name
# }

# output "instance_public_key" {
#   description = "Public key of efs_key"
#   value       = tls_private_key.ssh.public_key_openssh
#   sensitive   = true
# }
# output "instance_private_key" {
#   description = "Private key of efs_key"
#   value       =  tls_private_key.ssh.private_key_pem
#   sensitive   = true
# }