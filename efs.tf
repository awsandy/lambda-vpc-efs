variable "file_system_id" {
  type    = string
  default = "fs-552b7ea4"
}

data "aws_efs_file_system" "foo" {
  file_system_id = var.file_system_id
}

resource "aws_efs_access_point" "foo" {
  file_system_id = data.aws_efs_file_system.foo.id
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