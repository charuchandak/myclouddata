variable "key_name" { }

resource "tls_private_key" "charukey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.charukey.public_key_openssh
}
output "key"{
  value = "${aws_key_pair.generated_key.public_key}"
}
resource "null_resource" "nulllocal1"  {
	provisioner "local-exec" {
	    command = "echo  ${aws_key_pair.generated_key.public_key}"
  	}
}
