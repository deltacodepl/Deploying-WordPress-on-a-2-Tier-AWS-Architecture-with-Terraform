# resource "aws_iam_policy" "ec2_wordpress_policy" {
#   name = "ec2_wordpress_policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "s3:ListAllMyBuckets"
#         Resource = "*"
#       },
#       {
#         Effect   = "Allow"
#         Action   = "s3:*"
#         Resource = "arn:aws:s3:::${var.bucket_name}"
#       },
#       {
#         Effect   = "Allow"
#         Action   = "s3:*"
#         Resource = "arn:aws:s3:::${var.bucket_name}/*"
#       },
#     ]
#   })
# }

resource "aws_iam_role" "ec2_wordpress_role" {
  name               = "ec2_wordpress_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "ec2_wordpress_policy_attachment" {
#   policy_arn = aws_iam_policy.ec2_wordpress_policy.arn
#   role       = aws_iam_role.ec2_wordpress_role.name
# }

# resource "aws_iam_instance_profile" "ec2_wordpress_instance_profile" {
#   name = "ec2_wordpress_instance_profile"
#   role = aws_iam_role.ec2_wordpress_role.name
# }