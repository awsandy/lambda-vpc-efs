resource "null_resource" "eni-sg" {
  triggers = {
    sg       = aws_security_group.test_sg.id
    func     = aws_lambda_function.terraform_lambda_func.id
    vpcid  = aws_vpc.vpc.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = "/bin/bash ./del-eni.sh ${self.triggers.vpcid} ${self.triggers.sg}"
  }
}