variable "inbound_port_production_ec2" {
  type        = list(any)
  default     = [22, 80, 443, 81, 3306, 3307]
  description = "inbound port allow on production instance"
}

variable "db_name" {
  type    = string
  default = "wordpressdb"
}

variable "db_user" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "Wordpress-AWS2Tier"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# eu-central-1 22.04 LTS
variable "ami" {
  type    = string
  default = "ami-01a93368cab494eb5"
}

variable "availability_zone" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1d"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "list of all cidr for subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "target_application_port" {
  type    = string
  default = "443"
}

variable "private_key_location" {
  description = "Location of the private key"
  type        = string
  #default     = "/home/ko/.ssh/ko_aws_rsa"
  default = "/home/ko/.ssh/id_rsa_ko"
}

variable "pat" {
  type = string
  default = ""
}

variable "mount_directory" {
  type    = string
  default = "/var/www/html"
}

variable "bucket_name" {
  type    = string
  default = "my-s3-wordpress-bucket"
}
 
variable "s3_origin_id" {
  type    = string
  default = "my-s3-wordpress-origin"
}
