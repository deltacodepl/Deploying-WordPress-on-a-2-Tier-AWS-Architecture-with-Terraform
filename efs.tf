resource "aws_efs_file_system" "efs_volume" {
  creation_token = "efs_volume"
}

resource "aws_efs_mount_target" "efs_mount_target_1" {
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.ec2_1_public_subnet.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "efs_mount_target_2" {
  file_system_id  = aws_efs_file_system.efs_volume.id
  subnet_id       = aws_subnet.ec2_2_public_subnet.id
  security_groups = [aws_security_group.efs_sg.id]
}

# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

resource "aws_key_pair" "aws_ec2_access_key" {
  # key_name_prefix = "efs_key"
  key_name = "efs-key-pair"
  # public_key      = tls_private_key.ssh.public_key_openssh
  public_key = file("/home/ko/.ssh/ko_aws_rsa.pub")
  # public_key = file("/home/ko/.ssh/id_rsa_oak.pub")
}

# resource "local_file" "private_key" {
#   content  = tls_private_key.ssh.private_key_openssh
#   filename = var.private_key_location
# }

data "aws_instances" "production_instances" {
  instance_tags = {
    "Name" = "production-instance"
  }
  depends_on = [
    aws_instance.production_1_instance,
    #aws_instance.production_2_instance
  ]
}

resource "null_resource" "install_script" {
  count = 1

  depends_on = [
    #aws_db_instance.rds_master,
    #local_file.private_key,
    aws_efs_mount_target.efs_mount_target_1,
    aws_efs_mount_target.efs_mount_target_2,
    aws_instance.production_1_instance,
    #aws_instance.production_2_instance
  ]

  connection {
    type        = "ssh"
    host        = data.aws_instances.production_instances.public_ips[count.index]
    user        = "ubuntu"
    private_key = file(var.private_key_location)
  }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y",
#       # Add Docker's official GPG key:
#       "sudo apt-get update",
#       "sudo apt-get install ca-certificates curl",
#       "sudo install -m 0755 -d /etc/apt/keyrings",
#       "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
#       "sudo chmod a+r /etc/apt/keyrings/docker.asc",

# # Add the repository to Apt sources:
#       "echo \",
#       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#        sudo apt-get update
#              "sudo apt -y install amazon-efs-utils",
#              "sudo mkdir -p ${var.mount_directory}",
#              "sudo mount -t efs -o tls ${aws_efs_file_system.efs_volume.id}:/ ${var.mount_directory}",
#              "sudo docker run --name wordpress-docker -e WORDPRESS_DB_USER=${aws_db_instance.rds_master.username} -e WORDPRESS_DB_HOST=${aws_db_instance.rds_master.endpoint} -e WORDPRESS_DB_PASSWORD=${aws_db_instance.rds_master.password} -v ${var.mount_directory}:${var.mount_directory} -p 80:80 -d wordpress:4.8-apache",
#     ]
#   }

# provisioner "remote-exec" {
#   inline = [ 
#     "sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y",
#     "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
#     "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
#     "sudo chmod a+r /etc/apt/keyrings/docker.asc",
#     #"echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
#     "sudo apt-get update",
#     "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
#     "sudo usermod -aG docker ubuntu",
#     # "newgrp docker",
#     "sudo apt -y install nfs-common",
#     "sudo mkdir -p ${var.mount_directory}",
#     "sudo mount -t efs -o tls ${aws_efs_file_system.efs_volume.id}:/ ${var.mount_directory}",
#     "sudo docker run --name wordpress-docker -e WORDPRESS_DB_USER=${aws_db_instance.rds_master.username} -e WORDPRESS_DB_HOST=${aws_db_instance.rds_master.endpoint} -e WORDPRESS_DB_PASSWORD=${aws_db_instance.rds_master.password} -v ${var.mount_directory}:${var.mount_directory} -p 80:80 -d wordpress:4.8-apache",
#   ]
# }

provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y",
    "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y",
    "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl gnupg lsb-release",
    "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
    "sudo chmod a+r /etc/apt/keyrings/docker.asc",
    "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
    "sudo apt-get update",
    "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
    "sudo usermod -aG docker ubuntu",
    # "newgrp docker",
    "sudo DEBIAN_FRONTEND=noninteractive apt -y install nfs-common pkg-config libssl-dev openssl libssl-dev binutils",
    "curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y",
    "source ~/.cargo/env",
    "git clone https://github.com/aws/efs-utils && cd efs-utils > /dev/null && ./build-deb.sh && sudo apt-get -y install ./build/amazon-efs-utils*deb ",
    "sudo mkdir -p ${var.mount_directory}",
    "sudo mount -t efs -o tls ${aws_efs_file_system.efs_volume.id}:/ ${var.mount_directory}",
    "git clone https://github.com/deltacodepl/joomla-docker-compose.git",
    "git clone https://${var.pat}@github.com/deltacodepl/playec2.git",
    "mv playec2/code joomla-docker-compose",
    "mv playec2/db.tgz joomla-docker-compose",
    "cd joomla-docker-compose > /dev/null 2>&1 && tar -xzvf db.tgz",
    "sudo docker network create joomla-network > /dev/null",
    "sudo docker network create traefik-network > /dev/null",
    "sudo docker compose up -d",
    "",
  ]
}
}
