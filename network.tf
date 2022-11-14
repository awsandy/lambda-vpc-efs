resource "aws_vpc_endpoint" "efs" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.eu-west-2.elasticfilesystem"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.test_sg.id,
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.eu-west-2.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.test_sg.id,
  ]

  private_dns_enabled = true
}


resource aws_security_group test_sg {

  vpc_id = aws_vpc.vpc.id

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



resource "aws_vpc" "vpc" {
  cidr_block = "100.64.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  
  
  tags = {
    Name = "Lambda-efs"
  }
}

resource "aws_subnet" "private" {

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "100.64.0.0/24"

  tags = {
    Name = "Lambda isol"
  }
}

