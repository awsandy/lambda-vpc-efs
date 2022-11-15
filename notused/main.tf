# find efs file system for sagemaker
data "aws_efs_mount_target" "foo" {
  mount_target_id = aws_sgaemaker_domain.foo.home_efs_filesystem_id
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = data.aws_efs_mount_target.foo.security_groups[0]
}