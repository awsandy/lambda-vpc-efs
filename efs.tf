#variable "file_system_id" {
#  type    = string
#  default = "fs-552b7ea4"
#}

#data "aws_efs_file_system" "foo" {
#  file_system_id = sagemaker.foo.
#}



resource "aws_efs_file_system" "foo" {
  creation_token = "my-product"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "Lambda-efs"
  }


}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = aws_subnet.private.id
  security_groups = [aws_security_group.test_sg.id]
}



resource "aws_efs_access_point" "foo" {
#  file_system_id = data.aws_efs_file_system.foo.id
  file_system_id = aws_efs_file_system.foo.id
    posix_user {
    gid = 0 
    uid = 0

  }

 #   root_directory {
 #   path = "/lambda"
 #   creation_info {
 #     owner_gid   = 1000
 #     owner_uid   = 1000
 #     permissions = 0777
 #   }
 # }

}