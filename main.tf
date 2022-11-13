

resource "aws_iam_role" "lambda_role" {
name   = "AT_Test_Lambda_Function_Role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "aws_iam_policy_for_terraform_aws_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role2" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role3" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}
 
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/hello-python.zip"
}
 
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/python/hello-python.zip"
function_name                  = "at-lambda-efs"
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,aws_efs_access_point.foo]
vpc_config {
    security_group_ids = [aws_security_group.test_sg.id]
    subnet_ids         = [aws_subnet.private.id]
}
file_system_config {
    arn = aws_efs_access_point.foo.arn
    # Must start with '/mnt/'
    local_mount_path = "/mnt/efs"
}

environment {
    variables = {
      EFS_MOUNT_POINT = local.lambda_file_system_local_mount_path
    }
}

}


resource aws_security_group test_sg {

  vpc_id = data.aws_vpc.vpc.id

  ingress {
    cidr_blocks = [aws_subnet.private.cidr_block]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["100.64.0.0/16"]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]    
  }
}


#data "aws_subnet" "private_subnet" {
#  id = "subnet-0ec3f52feec87b364"
#}


data aws_vpc "vpc" {
id = "vpc-0d18b88f8596b92c3"
}

resource "aws_subnet" "private" {

  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = "100.64.4.0/24"

  tags = {
    Name = "Lambda isol"
  }
}




#data "aws_subnets" "private" {
#  filter {
#    name   = "vpc-id"
#    values = [data.aws_vpc.vpc.id]
#  }#

#  tags = {
#    Tier = "priv"
#  }
#}

