resource "aws_instance" "apache" {
  ami           = "ami-052c08d70def0ac62"
  instance_type = "t2.micro"
  key_name = "charukey"
  security_groups = [ "mysg01" ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/hp/Downloads/charukey.pem")
    
host     = aws_instance.apache.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install python3   -y",
      "sudo pip3 install ansible  -y",
      "sudo mkdir /etc/ansible",
      "sudo yum install httpd  php git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",,

    ]
  }

  tags = {
    Name = "apacheserver"
  }

}


resource "aws_ebs_volume" "ebs1" {
  availability_zone = aws_instance.apache.availability_zone
  size              = 1
  tags = {
    Name = "charu-ebs"
  }
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs1.id
  instance_id = aws_instance.apache.id
  force_detach = true
}


output "myos_ip" {
  value = aws_instance.apache.public_ip
}


resource "null_resource" "nulllocal2"  {
	provisioner "local-exec" {
	    command = "echo  ${aws_instance.apache.public_ip} > publicip.txt"
  	}
}



resource "null_resource" "nullremote3"  {

depends_on = [
    aws_volume_attachment.ebs_att,
  ]


  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/hp/Downloads/charukey.pem")
    host     = aws_instance.apache.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4  /dev/xvdh",
      "sudo mount  /dev/xvdh  /var/www/html",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/charuchandak/myclouddata.git /var/www/html/"
    ]
  }
}



resource "null_resource" "nulllocal1"  {


depends_on = [
    null_resource.nullremote3,
  ]

	provisioner "local-exec" {
	    command = "chrome  ${aws_instance.apache.public_ip}"
  	}
}


