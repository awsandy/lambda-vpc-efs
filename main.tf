


 
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
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,aws_efs_access_point.foo,aws_efs_mount_target.alpha,aws_vpc_endpoint.efs]
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
      EFS_MOUNT_POINT = "/mnt/efs"
    }
}

}


