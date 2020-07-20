

resource "aws_instance"  "instance" {
  ami           = "ami-052c08d70def0ac62"
  instance_type = "t2.micro"

  key_name	= aws_key_pair.deployer.key_name
  security_groups =  [ "secure","secure1" ] 

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.keypair.private_key_pem
    host     = aws_instance.instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd  -y",
      "sudo yum install amazon-efs-utils -y",
      "sudo yum install nfs-utils -y",
      "sudo yum install php -y",
      "sudo yum install git -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
    ]
  }


  tags = {
    Name = "httpos1"
  }
}

resource "null_resource" "nullremote3"  {

depends_on = [
    aws_efs_mount_target.alpha,
    null_resource.nulllocal5
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.keypair.private_key_pem
    host     = aws_instance.instance.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sleep 40",
      "sudo chmod ugo+rw /etc/fstab",
      "sudo echo '${aws_efs_file_system.EFS.id}:/ /var/www/html efstls,_netdev' >> /etc/fstab",
      "sudo mount -a -t efs,nfs4 defaults",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/chirag0202/cloudtask2-html.git /var/www/html/"
    ]
  }
}
